import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'user_mapper.dart';

///
extension ReadEntityX on ReadEntity {
  ///
  Read toRead({User user}) {
    return Read(
      user: user,
      lastRead: lastRead,
      unreadMessages: unreadMessages,
    );
  }
}

///
extension ReadX on Read {
  ///
  ReadEntity toEntity({String cid}) {
    return ReadEntity(
      lastRead: lastRead,
      userId: user?.id,
      channelCid: cid,
      unreadMessages: unreadMessages,
    );
  }
}
