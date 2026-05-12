// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_message_dao.dart';

// ignore_for_file: type=lint
mixin _$PinnedMessageDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $PinnedMessagesTable get pinnedMessages => attachedDatabase.pinnedMessages;
  $UsersTable get users => attachedDatabase.users;
  PinnedMessageDaoManager get managers => PinnedMessageDaoManager(this);
}

class PinnedMessageDaoManager {
  final _$PinnedMessageDaoMixin _db;
  PinnedMessageDaoManager(this._db);
  $$PinnedMessagesTableTableManager get pinnedMessages => $$PinnedMessagesTableTableManager(
    _db.attachedDatabase,
    _db.pinnedMessages,
  );
  $$UsersTableTableManager get users => $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
