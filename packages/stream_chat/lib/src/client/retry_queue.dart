import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import '../../stream_chat.dart';

/// The retry queue associated to a channel.
class RetryQueue {
  /// Instantiate a new RetryQueue object.
  RetryQueue({
    required this.channel,
    String tag = 'SCh:RetryQueue',
  }) : client = channel.client,
       logger = StreamLogger(tag) {
    _retryPolicy = client.retryPolicy;
    _listenConnectionRecovered();
  }

  /// Writes this queue's records.
  final StreamLogger logger;

  /// The channel of this queue.
  final Channel channel;

  /// The client associated with this [channel].
  final StreamChatClient client;

  late final RetryPolicy _retryPolicy;

  final _compositeSubscription = CompositeSubscription();

  final _messageQueue = HeapPriorityQueue(_byDate);

  void _listenConnectionRecovered() {
    client
        .on(EventType.connectionRecovered)
        .distinct()
        .listen((event) {
          if (event.online == true) {
            logger.d(() => 'Connection recovered, retrying failed messages');
            channel.state?.retryFailedMessages();
          }
        })
        .addTo(_compositeSubscription);
  }

  /// Add a list of messages.
  void add(Iterable<Message> messages) {
    assert(
      messages.every((it) => it.state.isFailed),
      'Only failed messages can be added to the queue',
    );

    // Filter out messages that are already in the queue.
    final messagesToAdd = messages.whereNot(_messageQueue.containsMessage);

    // If there are no messages to add, return.
    if (messagesToAdd.isEmpty) return;

    logger.d(() => 'Adding ${messagesToAdd.length} messages to the queue');
    _messageQueue.addAll(messagesToAdd);

    _processQueue();
  }

  bool _isProcessing = false;

  final _random = math.Random();

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    logger.d(() => 'Started retrying failed messages');
    while (_messageQueue.isNotEmpty) {
      logger.v(() => '${_messageQueue.length} messages remaining in the queue');

      final message = _messageQueue.first;
      final retryPolicy = _retryPolicy;
      try {
        final result = await _retry(message, retryPolicy);
        if (result case Failure(:final error)) _restoreFailedMessage(message, error);
      } catch (error) {
        _restoreFailedMessage(message, error);
      } finally {
        // remove the message from the queue after it's handled.
        _messageQueue.removeMessage(message);
      }
    }

    _isProcessing = false;
  }

  // Logs that [message] could not be retried, and puts it back in the channel
  // state in its failed state.
  void _restoreFailedMessage(Message message, Object error) {
    logger.e(() => 'Error while retrying message ${message.id}', error: error);
    channel.state?.updateMessage(message);
  }

  // Retries [message] until it succeeds, fails in a way [policy] does not
  // retry, or runs out of attempts, waiting longer before each new attempt.
  Future<Result<Object>> _retry(Message message, RetryPolicy policy) async {
    for (var attempt = 1; ; attempt += 1) {
      final result = await channel.retryMessage(message);
      if (result is! Failure) return result;

      final error = result.error;
      if (attempt >= policy.maxRetryAttempts) return result;
      if (error is! StreamChatException) return result;
      if (!await policy.shouldRetry(client, attempt, error)) return result;

      await Future<void>.delayed(_backOffDelay(policy, attempt));
    }
  }

  // The wait after the failed [attempt]: the policy's delay factor, doubled
  // for every attempt up to 2^31 so it cannot overflow, randomized by its
  // randomization factor and capped at its maximum delay.
  Duration _backOffDelay(RetryPolicy policy, int attempt) {
    final randomization = policy.randomizationFactor * (_random.nextDouble() * 2 - 1) + 1;
    final delay = policy.delayFactor * math.pow(2, math.min(attempt, 31)) * randomization;
    return delay < policy.maxDelay ? delay : policy.maxDelay;
  }

  /// Whether our [_messageQueue] has messages or not.
  bool get hasMessages => _messageQueue.isNotEmpty;

  /// Returns true if the queue contains the given [message].
  bool contains(Message message) => _messageQueue.containsMessage(message);

  /// Call this method to dispose this object.
  void dispose() {
    _messageQueue.clear();
    _compositeSubscription.dispose();
  }

  static int _byDate(Message m1, Message m2) {
    final date1 = _getMessageDate(m1);
    final date2 = _getMessageDate(m2);

    if (date1 == null && date2 == null) return 0;
    if (date1 == null) return 1;
    if (date2 == null) return -1;
    return date1.compareTo(date2);
  }

  static DateTime? _getMessageDate(Message message) {
    return message.state.maybeMap(
      failed: (it) => it.state.map(
        sendingFailed: (_) => message.createdAt,
        updatingFailed: (_) => message.updatedAt,
        partialUpdatingFailed: (_) => message.updatedAt,
        deletingFailed: (_) => message.deletedAt,
      ),
      orElse: () => null,
    );
  }
}

extension on HeapPriorityQueue<Message> {
  bool removeMessage(Message message) {
    for (final element in unorderedElements) {
      if (element.id == message.id) {
        return remove(element);
      }
    }

    return false;
  }

  bool containsMessage(Message message) {
    for (final element in unorderedElements) {
      if (element.id == message.id) return true;
    }

    return false;
  }
}
