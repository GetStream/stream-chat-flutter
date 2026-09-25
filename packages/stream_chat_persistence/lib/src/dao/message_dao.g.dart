// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dao.dart';

// ignore_for_file: type=lint
mixin _$MessageDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $ChannelsTable get channels => attachedDatabase.channels;
  $MessagesTable get messages => attachedDatabase.messages;
  $UsersTable get users => attachedDatabase.users;
  MessageDaoManager get managers => MessageDaoManager(this);
}

class MessageDaoManager {
  final _$MessageDaoMixin _db;
  MessageDaoManager(this._db);
  $$ChannelsTableTableManager get channels => $$ChannelsTableTableManager(_db.attachedDatabase, _db.channels);
  $$MessagesTableTableManager get messages => $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
  $$UsersTableTableManager get users => $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
