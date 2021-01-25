import 'package:stream_chat/stream_chat.dart';
import 'user_mapper.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

///
extension ConnectionEventX on ConnectionEventEntity {
  ///
  Event toEvent({User user}) {
    return Event(
      me: user,
      totalUnreadCount: totalUnreadCount,
      unreadChannels: unreadChannels,
    );
  }
}
