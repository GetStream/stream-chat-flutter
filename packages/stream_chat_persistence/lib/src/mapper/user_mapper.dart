import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

///
extension UserEntityX on UserEntity {
  ///
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

///
extension UserX on User {
  ///
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
