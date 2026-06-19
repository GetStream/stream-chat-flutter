// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_message_reaction_dao.dart';

// ignore_for_file: type=lint
mixin _$PinnedMessageReactionDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $PinnedMessageReactionsTable get pinnedMessageReactions => attachedDatabase.pinnedMessageReactions;
  $UsersTable get users => attachedDatabase.users;
  PinnedMessageReactionDaoManager get managers => PinnedMessageReactionDaoManager(this);
}

class PinnedMessageReactionDaoManager {
  final _$PinnedMessageReactionDaoMixin _db;
  PinnedMessageReactionDaoManager(this._db);
  $$PinnedMessageReactionsTableTableManager get pinnedMessageReactions => $$PinnedMessageReactionsTableTableManager(
    _db.attachedDatabase,
    _db.pinnedMessageReactions,
  );
  $$UsersTableTableManager get users => $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
