// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_vote_dao.dart';

// ignore_for_file: type=lint
mixin _$PollVoteDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $PollsTable get polls => attachedDatabase.polls;
  $PollVotesTable get pollVotes => attachedDatabase.pollVotes;
  $UsersTable get users => attachedDatabase.users;
  PollVoteDaoManager get managers => PollVoteDaoManager(this);
}

class PollVoteDaoManager {
  final _$PollVoteDaoMixin _db;
  PollVoteDaoManager(this._db);
  $$PollsTableTableManager get polls => $$PollsTableTableManager(_db.attachedDatabase, _db.polls);
  $$PollVotesTableTableManager get pollVotes => $$PollVotesTableTableManager(_db.attachedDatabase, _db.pollVotes);
  $$UsersTableTableManager get users => $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
