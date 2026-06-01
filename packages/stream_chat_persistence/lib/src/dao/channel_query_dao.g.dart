// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_query_dao.dart';

// ignore_for_file: type=lint
mixin _$ChannelQueryDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $ChannelQueriesTable get channelQueries => attachedDatabase.channelQueries;
  $ChannelsTable get channels => attachedDatabase.channels;
  $UsersTable get users => attachedDatabase.users;
  ChannelQueryDaoManager get managers => ChannelQueryDaoManager(this);
}

class ChannelQueryDaoManager {
  final _$ChannelQueryDaoMixin _db;
  ChannelQueryDaoManager(this._db);
  $$ChannelQueriesTableTableManager get channelQueries =>
      $$ChannelQueriesTableTableManager(
          _db.attachedDatabase, _db.channelQueries);
  $$ChannelsTableTableManager get channels =>
      $$ChannelsTableTableManager(_db.attachedDatabase, _db.channels);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
