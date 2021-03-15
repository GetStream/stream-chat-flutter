import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// Useful mapping functions for [ReadEntity]
extension ReadEntityX on ReadEntity {
  /// Maps a [ReadEntity] into [Read]
  Read toRead({User user}) => Read(
      user: user,
      lastRead: lastRead,
      unreadMessages: unreadMessages,
    );
}

/// Useful mapping functions for [Read]
extension ReadX on Read {
  /// Maps a [Read] into [ReadEntity]
  ReadEntity toEntity({String cid}) => ReadEntity(
      lastRead: lastRead,
      userId: user?.id,
      channelCid: cid,
      unreadMessages: unreadMessages,
    );
}
