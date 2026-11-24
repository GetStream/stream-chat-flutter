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
  /// Does nothing unless [MessageRules.canMarkAsPlayed] allows it. Sends at
  /// most one mark per message on each channel. Never completes with an
  /// error; after a failed request the next call tries again.
  Future<void> sendPlayedMarkOnce(Message message) async {
    if (!MessageRules.canMarkAsPlayed(message, this)) return;

    final markedIds = _markedMessageIds[this] ??= {};
    if (!markedIds.add(message.id)) return;

    try {
      await sendMessageMark(message, MessageMarkType.played);
    } catch (error, stackTrace) {
      markedIds.remove(message.id);
      client.logger.fine('Could not mark message ${message.id} played', error, stackTrace);
    }
  }
}
