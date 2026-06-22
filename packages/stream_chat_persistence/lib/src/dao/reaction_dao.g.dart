// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_dao.dart';

// ignore_for_file: type=lint
mixin _$ReactionDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $ReactionsTable get reactions => attachedDatabase.reactions;
  $UsersTable get users => attachedDatabase.users;
  ReactionDaoManager get managers => ReactionDaoManager(this);
}

class ReactionDaoManager {
  final _$ReactionDaoMixin _db;
  ReactionDaoManager(this._db);
  $$ReactionsTableTableManager get reactions => $$ReactionsTableTableManager(_db.attachedDatabase, _db.reactions);
  $$UsersTableTableManager get users => $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
