// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_dao.dart';

// ignore_for_file: type=lint
mixin _$ReactionDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $ChannelsTable get channels => attachedDatabase.channels;
  $MessagesTable get messages => attachedDatabase.messages;
  $ReactionsTable get reactions => attachedDatabase.reactions;
  $UsersTable get users => attachedDatabase.users;
  ReactionDaoManager get managers => ReactionDaoManager(this);
}

class ReactionDaoManager {
  final _$ReactionDaoMixin _db;
  ReactionDaoManager(this._db);
  $$ChannelsTableTableManager get channels => $$ChannelsTableTableManager(_db.attachedDatabase, _db.channels);
  $$MessagesTableTableManager get messages => $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
  $$ReactionsTableTableManager get reactions => $$ReactionsTableTableManager(_db.attachedDatabase, _db.reactions);
  $$UsersTableTableManager get users => $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
