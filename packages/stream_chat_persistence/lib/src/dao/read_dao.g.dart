// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_dao.dart';

// ignore_for_file: type=lint
mixin _$ReadDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $ChannelsTable get channels => attachedDatabase.channels;
  $ReadsTable get reads => attachedDatabase.reads;
  $UsersTable get users => attachedDatabase.users;
  ReadDaoManager get managers => ReadDaoManager(this);
}

class ReadDaoManager {
  final _$ReadDaoMixin _db;
  ReadDaoManager(this._db);
  $$ChannelsTableTableManager get channels => $$ChannelsTableTableManager(_db.attachedDatabase, _db.channels);
  $$ReadsTableTableManager get reads => $$ReadsTableTableManager(_db.attachedDatabase, _db.reads);
  $$UsersTableTableManager get users => $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
