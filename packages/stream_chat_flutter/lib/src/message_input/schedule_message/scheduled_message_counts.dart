import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// The counts of scheduled messages in a channel or thread.
///
/// [channelPending] counts the pending messages of the whole channel, thread
/// replies included, as they all count toward its limit.
@internal
class ScheduledMessageCounts extends Equatable {
  /// Creates counts of scheduled messages.
  const ScheduledMessageCounts({
    required this.failed,
    required this.pending,
    required this.channelPending,
  });

  /// Counts [scheduledMessages] in the channel [cid], or in the thread of
  /// [parentId] when it is set.
  factory ScheduledMessageCounts.of(
    List<ScheduledMessage> scheduledMessages, {
    required String cid,
    String? parentId,
  }) {
    var failed = 0;
    var pending = 0;
    var channelPending = 0;
    for (final it in scheduledMessages) {
      if (it.cid != cid) continue;

      final isPending = it.status.isPending;
      if (isPending) channelPending += 1;

      // A channel counts its own messages, a thread its replies.
      if (it.message.parentId != parentId) continue;
      if (it.status == .failed) failed += 1;
      if (isPending) pending += 1;
    }

    return ScheduledMessageCounts(
      failed: failed,
      pending: pending,
      channelPending: channelPending,
    );
  }

  /// The failed messages in the channel or thread.
  final int failed;

  /// The scheduled and sending messages in the channel or thread.
  final int pending;

  /// The pending messages of the whole channel, thread replies included.
  final int channelPending;

  /// Whether any message failed.
  bool get hasFailed => failed > 0;

  /// Whether any message is scheduled or sending.
  bool get hasPending => pending > 0;

  /// Every field must be listed, or the banner skips rebuilds it needs.
  @override
  List<Object?> get props => [failed, pending, channelPending];
}
