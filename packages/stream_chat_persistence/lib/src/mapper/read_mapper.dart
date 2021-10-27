import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [ReadEntity]
extension ReadEntityX on ReadEntity {
  /// Maps a [ReadEntity] into [Read]
  Read toRead({required User user}) => Read(
        user: user,
        lastRead: lastRead,
        unreadMessages: unreadMessages,
      );
}

/// Useful mapping functions for [Read]
extension ReadX on Read {
  /// Maps a [Read] into [ReadEntity]
  ReadEntity toEntity({required String cid}) => ReadEntity(
        lastRead: lastRead,
        userId: user.id,
        channelCid: cid,
        unreadMessages: unreadMessages,
      );
}
