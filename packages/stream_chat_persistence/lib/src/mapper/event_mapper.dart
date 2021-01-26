import 'package:stream_chat/stream_chat.dart';
import 'user_mapper.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

///
extension ConnectionEventX on ConnectionEventEntity {
  ///
  Event toEvent() {
    return Event(
      me: ownUser != null ? OwnUser.fromJson(ownUser) : null,
      totalUnreadCount: totalUnreadCount,
      unreadChannels: unreadChannels,
    );
  }
}
