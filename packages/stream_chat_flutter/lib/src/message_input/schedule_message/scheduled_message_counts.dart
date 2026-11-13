import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// The counts of scheduled messages in a channel or thread.
///
/// [channelPending] counts the pending messages of the whole channel, thread
/// replies included, and [userPending] those of every channel, as they count
/// toward the channel's and the user's limits.
@internal
class ScheduledMessageCounts extends Equatable {
  /// Creates counts of scheduled messages.
  const ScheduledMessageCounts({
    required this.failed,
    required this.pending,
    required this.channelPending,
    required this.userPending,
    this.nextScheduledAt,
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
    var userPending = 0;
    DateTime? nextScheduledAt;
    for (final it in scheduledMessages) {
      // A failed edit is still scheduled as it was before.
      final isPending = it.status.isPending || it.failureReason == .updateFailed;
      if (isPending) userPending += 1;
      if (it.cid != cid) continue;
      if (isPending) channelPending += 1;

      // A channel counts its own messages, a thread its replies.
      if (it.message.parentId != parentId) continue;
      if (it.status == .failed) failed += 1;
      if (!isPending) continue;

      pending += 1;
      final scheduledAt = it.scheduledAt;
      if (nextScheduledAt == null || scheduledAt.isBefore(nextScheduledAt)) {
        nextScheduledAt = scheduledAt;
      }
    }

    return ScheduledMessageCounts(
      failed: failed,
      pending: pending,
      channelPending: channelPending,
      userPending: userPending,
      nextScheduledAt: nextScheduledAt,
    );
  }

  /// The failed messages in the channel or thread.
  final int failed;

  /// The messages still to be sent in the channel or thread.
  final int pending;

  /// The pending messages of the whole channel, thread replies included.
  final int channelPending;

  /// The pending messages of every channel.
  final int userPending;

  /// When the first pending message in the channel or thread is sent, or null
  /// when none is pending.
  final DateTime? nextScheduledAt;

  /// Whether any message failed.
  bool get hasFailed => failed > 0;

  /// Whether any message is still to be sent in the channel or thread.
  bool get hasPending => pending > 0;

  // Every field must be listed, or the banner skips rebuilds it needs.
  @override
  List<Object?> get props => [failed, pending, channelPending, userPending, nextScheduledAt];
}
