// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_dao.dart';

// ignore_for_file: type=lint
mixin _$LocationDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $ChannelsTable get channels => attachedDatabase.channels;
  $MessagesTable get messages => attachedDatabase.messages;
  $LocationsTable get locations => attachedDatabase.locations;
  LocationDaoManager get managers => LocationDaoManager(this);
}

class LocationDaoManager {
  final _$LocationDaoMixin _db;
  LocationDaoManager(this._db);
  $$ChannelsTableTableManager get channels => $$ChannelsTableTableManager(_db.attachedDatabase, _db.channels);
  $$MessagesTableTableManager get messages => $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
  $$LocationsTableTableManager get locations => $$LocationsTableTableManager(_db.attachedDatabase, _db.locations);
}
