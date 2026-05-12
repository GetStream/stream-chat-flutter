// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_dao.dart';

// ignore_for_file: type=lint
mixin _$PollDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $PollsTable get polls => attachedDatabase.polls;
  $PollVotesTable get pollVotes => attachedDatabase.pollVotes;
  $UsersTable get users => attachedDatabase.users;
  PollDaoManager get managers => PollDaoManager(this);
}

class PollDaoManager {
  final _$PollDaoMixin _db;
  PollDaoManager(this._db);
  $$PollsTableTableManager get polls => $$PollsTableTableManager(_db.attachedDatabase, _db.polls);
  $$PollVotesTableTableManager get pollVotes => $$PollVotesTableTableManager(_db.attachedDatabase, _db.pollVotes);
  $$UsersTableTableManager get users => $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
