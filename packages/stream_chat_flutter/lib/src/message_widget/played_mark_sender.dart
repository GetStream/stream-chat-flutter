import 'package:meta/meta.dart';

import '../../stream_chat_flutter.dart';

// Ids of the messages each channel is marking or has marked played, so a
// replay or another player sends nothing.
final _markedMessageIds = Expando<Set<String>>();

/// Marks messages played on behalf of the current user.
@internal
extension PlayedMarkSender on Channel {
  /// Marks [message] played.
  ///
  /// Does nothing when the channel doesn't allow played marks, when the
  /// current user sent [message] or it has no sender yet, or when the user
  /// already played it. Sends at most one mark per message on each channel.
  /// Never completes with an error; after a failed request the next call
  /// tries again.
  Future<void> sendPlayedMarkOnce(Message message) async {
    if (!_shouldMarkPlayed(message)) return;

    final markedIds = _markedMessageIds[this] ??= {};
    if (!markedIds.add(message.id)) return;

    try {
      await sendMessageMark(message, MessageMarkType.played);
    } catch (error, stackTrace) {
      markedIds.remove(message.id);
      client.logger.fine(
        'Could not mark message ${message.id} played',
        error,
        stackTrace,
      );
    }
  }

  bool _shouldMarkPlayed(Message message) {
    if (!canSendMessageMark) return false;

    final senderId = message.user?.id;
    if (senderId == null) return false;
    if (senderId == client.state.currentUser?.id) return false;

    final ownMarks = message.ownMarks ?? const [];
    return !ownMarks.any((it) => it.type == MessageMarkType.played);
  }
}
