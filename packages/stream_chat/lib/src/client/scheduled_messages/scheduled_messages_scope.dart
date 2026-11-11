import 'package:collection/collection.dart';

import '../../core/models/scheduled_message.dart';
import '../client.dart';

/// Subsets of a [ClientState]'s scheduled messages in one channel or thread.
extension ScheduledMessagesScope on ClientState {
  /// The scheduled messages in the channel [cid], without its thread replies.
  ///
  /// They are the ones in [ClientState.scheduledMessages] in that channel, in
  /// the same order.
  List<ScheduledMessage> scheduledChannelMessages(String cid) {
    return _scoped(_inChannel(cid));
  }

  /// The [scheduledChannelMessages], emitted on listen and again each time they
  /// change.
  Stream<List<ScheduledMessage>> scheduledChannelMessagesStream(String cid) {
    return _scopedStream(_inChannel(cid));
  }

  /// The scheduled replies in the thread of the message [parentId].
  ///
  /// They are the ones in [ClientState.scheduledMessages] replying to it, in
  /// the same order.
  List<ScheduledMessage> scheduledThreadReplies(String parentId) {
    return _scoped(_inThread(parentId));
  }

  /// The [scheduledThreadReplies], emitted on listen and again each time they
  /// change.
  Stream<List<ScheduledMessage>> scheduledThreadRepliesStream(String parentId) {
    return _scopedStream(_inThread(parentId));
  }

  static bool Function(ScheduledMessage) _inChannel(String cid) {
    return (it) => it.cid == cid && it.message.parentId == null;
  }

  static bool Function(ScheduledMessage) _inThread(String parentId) {
    return (it) => it.message.parentId == parentId;
  }

  List<ScheduledMessage> _scoped(bool Function(ScheduledMessage) test) {
    return scheduledMessages.where(test).toList();
  }

  Stream<List<ScheduledMessage>> _scopedStream(
    bool Function(ScheduledMessage) test,
  ) {
    final scoped = scheduledMessagesStream.map((it) => it.where(test).toList());

    return scoped.distinct(const ListEquality().equals);
  }
}
