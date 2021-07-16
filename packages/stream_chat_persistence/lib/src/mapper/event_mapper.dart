import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// Useful mapping functions for [ConnectionEventEntity]
extension ConnectionEventX on ConnectionEventEntity {
  /// Maps a [ConnectionEventEntity] into [Event]
  Event toEvent() => Event(
        type: type,
        createdAt: lastEventAt,
        me: ownUser != null ? OwnUser.fromJson(ownUser!) : null,
        totalUnreadCount: totalUnreadCount,
        unreadChannels: unreadChannels,
      );
}
