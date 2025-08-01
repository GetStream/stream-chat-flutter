import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [UserEntity]
extension UserEntityX on UserEntity {
  /// Maps a [UserEntity] into [User]
  User toUser() => User(
        id: id,
        updatedAt: updatedAt,
        language: language,
        role: role,
        online: online,
        lastActive: lastActive,
        extraData: extraData,
        banned: banned,
        createdAt: createdAt,
        teamsRole: teamsRole,
        avgResponseTime: avgResponseTime,
      );
}

/// Useful mapping functions for [User]
extension UserX on User {
  /// Maps a [User] into [UserEntity]
  UserEntity toEntity() => UserEntity(
        id: id,
        role: role,
        language: language,
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastActive: lastActive,
        online: online,
        banned: banned,
        teamsRole: teamsRole,
        avgResponseTime: avgResponseTime,
        extraData: extraData,
      );
}
