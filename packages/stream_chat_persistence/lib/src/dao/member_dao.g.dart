// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_dao.dart';

// ignore_for_file: type=lint
mixin _$MemberDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $ChannelsTable get channels => attachedDatabase.channels;
  $MembersTable get members => attachedDatabase.members;
  $UsersTable get users => attachedDatabase.users;
  MemberDaoManager get managers => MemberDaoManager(this);
}

class MemberDaoManager {
  final _$MemberDaoMixin _db;
  MemberDaoManager(this._db);
  $$ChannelsTableTableManager get channels =>
      $$ChannelsTableTableManager(_db.attachedDatabase, _db.channels);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db.attachedDatabase, _db.members);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
