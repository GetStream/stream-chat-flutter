import 'package:logging/logging.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:stream_chat/src/client/channel.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/message_delivery.dart';
import 'package:stream_chat/src/core/util/message_rules.dart';
import 'package:synchronized/synchronized.dart';

/// A callback that sends delivery receipts for multiple channels.
///
/// Each [MessageDeliveryInfo] represents an acknowledgment that the current
/// user has received a message.
typedef MarkChannelsDelivered = Future<void> Function(
  Iterable<MessageDelivery> deliveries,
);

/// Manages the delivery reporting for channel messages.
///
/// Collects channels that need delivery acknowledgments and efficiently
/// reports them to the server.
class ChannelDeliveryReporter {
  /// Creates a new channel delivery reporter.
  ///
  /// The [onMarkChannelsDelivered] callback is invoked when delivery receipts
  /// are ready to be sent to the server.
  ///
  /// The [throttleDuration] controls how frequently delivery receipts are sent.
  ///
  /// The optional [logger] logs warnings and errors during operation.
  ChannelDeliveryReporter({
    Logger? logger,
    required this.onMarkChannelsDelivered,
    Duration throttleDuration = const Duration(seconds: 1),
  })  : _logger = logger,
        _markAsDeliveredThrottleDuration = throttleDuration;

  final Logger? _logger;
  final Duration _markAsDeliveredThrottleDuration;

  /// The callback invoked to send delivery receipts.
  ///
  /// Receives delivery receipts acknowledging that messages were received.
  final MarkChannelsDelivered onMarkChannelsDelivered;

  final _deliveryCandidatesLock = Lock();
  final _deliveryCandidates = <String /* cid */, Message /* message */ >{};

  /// Submits [channels] for delivery reporting.
  ///
  /// Marks each channel's last message as delivered if it meets the delivery
  /// requirements according to [MessageRules.canMarkAsDelivered]. Channels
  /// without a valid cid or last message are skipped.
  ///
  /// Typically used after message.new events or initial channel queries. For
  /// read/delivered events see [reconcileDelivery], for hidden/left channels
  /// see [cancelDelivery].
  Future<void> submitForDelivery(Iterable<Channel> channels) async {
    await _deliveryCandidatesLock.synchronized(() {
      for (final channel in channels) {
        final channelCid = channel.cid;
        if (channelCid == null) continue;

        final lastMessage = channel.state?.lastMessage;
        if (lastMessage == null) continue;

        // Only submit for delivery if the message can be marked as delivered.
        if (!MessageRules.canMarkAsDelivered(lastMessage, channel)) continue;

        _logger?.fine(
          'Submitted channel $channelCid for delivery '
          '(message: ${lastMessage.id})',
        );

        // Update the latest message for the channel
        _deliveryCandidates[channelCid] = lastMessage;
      }
    });

    // Trigger mark channels delivered request
    _throttledMarkCandidatesAsDelivered.call();
  }

  /// Reconciles delivery reporting for [channels] with their current state.
  ///
  /// Re-evaluates whether messages still need to be marked as delivered based
  /// on the channel's current state. Stops tracking messages that are already
  /// read, delivered, or otherwise don't need delivery reporting.
  ///
  /// This prevents duplicate delivery reports when a message is marked
  /// delivered on another device, and avoids unnecessary reports when a user
  /// reads a channel (since read supersedes delivered).
  ///
  /// Typically used after message.read or message.delivered events. See
  /// [cancelDelivery] to remove channels entirely, or [submitForDelivery]
  /// to add new messages.
  ///
  /// ```dart
  /// // After a message.read or message.delivered event
  /// reporter.reconcileDelivery([channel]);
  /// ```
  Future<void> reconcileDelivery(Iterable<Channel> channels) async {
    return _deliveryCandidatesLock.synchronized(() {
      for (final channel in channels) {
        final channelCid = channel.cid;
        if (channelCid == null) continue;

        // Get the existing candidate message
        final message = _deliveryCandidates[channelCid];
        if (message == null) continue;

        // If the message can still be marked as delivered, keep it
        if (MessageRules.canMarkAsDelivered(message, channel)) continue;

        _logger?.fine(
          'Reconciled delivery for channel $channelCid '
          '(message: ${message.id}), removing from candidates',
        );

        // Otherwise, remove it from the candidates
        _deliveryCandidates.remove(channelCid);
      }
    });
  }

  /// Cancels pending delivery reports for [channels].
  ///
  /// Prevents the specified channels from being marked as delivered. Typically
  /// used when channels are hidden, left, or removed from view.
  ///
  /// See [reconcileDelivery] to re-evaluate based on current read/delivered
  /// state instead of removing channels entirely.
  Future<void> cancelDelivery(Iterable<String> channels) {
    return _deliveryCandidatesLock.synchronized(() {
      for (final channelCid in channels) {
        if (!_deliveryCandidates.containsKey(channelCid)) continue;

        final message = _deliveryCandidates.remove(channelCid);

        _logger?.fine(
          'Canceled delivery for channel $channelCid '
          '(message: ${message?.id})',
        );
      }
    });
  }

  late final _throttledMarkCandidatesAsDelivered = Throttle(
    leading: false,
    _markCandidatesAsDelivered,
    _markAsDeliveredThrottleDuration,
  );

  static const _maxCandidatesPerBatch = 100;
  Future<void> _markCandidatesAsDelivered() async {
    // We only process at-most 100 channels at a time to avoid large payloads.
    final batch = {..._deliveryCandidates}.entries.take(_maxCandidatesPerBatch);
    final messageDeliveries = batch.map(
      (it) => MessageDelivery(channelCid: it.key, messageId: it.value.id),
    );

    if (messageDeliveries.isEmpty) return;

    _logger?.info('Marking ${messageDeliveries.length} channels as delivered');

    try {
      await onMarkChannelsDelivered(messageDeliveries);

      // Clear the successfully delivered candidates. If a channel's message ID
      // has changed since we started delivery, keep it for the next batch.
      await _deliveryCandidatesLock.synchronized(() {
        for (final delivery in messageDeliveries) {
          final deliveredChannelCid = delivery.channelCid;
          final deliveredMessageId = delivery.messageId;

          final currentMessage = _deliveryCandidates[deliveredChannelCid];
          // Skip removal if a newer message has been added while we were
          // processing the current batch.
          if (currentMessage?.id != deliveredMessageId) continue;
          _deliveryCandidates.remove(deliveredChannelCid);
        }

        // Schedule the next batch if there are remaining candidates.
        if (_deliveryCandidates.isNotEmpty) {
          _throttledMarkCandidatesAsDelivered.call();
        }
      });
    } catch (e, stk) {
      _logger?.warning('Failed to mark channels as delivered', e, stk);
    }
  }

  /// Cancels all pending delivery reports.
  ///
  /// Typically used when shutting down the reporter or permanently stopping
  /// delivery reporting.
  void cancel() {
    _throttledMarkCandidatesAsDelivered.cancel();
    _deliveryCandidatesLock.synchronized(_deliveryCandidates.clear);
  }
}
