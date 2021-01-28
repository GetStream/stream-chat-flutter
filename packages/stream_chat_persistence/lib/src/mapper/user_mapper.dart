import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// Useful mapping functions for [UserEntity]
extension UserEntityX on UserEntity {
  /// Maps a [UserEntity] into [User]
  User toUser() {
    return User(
      id: id,
      updatedAt: updatedAt,
      role: role,
      online: online,
      lastActive: lastActive,
      extraData: extraData,
      banned: banned,
      createdAt: createdAt,
    );
  }
}

/// Useful mapping functions for [User]
extension UserX on User {
  /// Maps a [User] into [UserEntity]
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastActive: lastActive,
      online: online,
      banned: banned,
      extraData: extraData,
    );
  }
}
