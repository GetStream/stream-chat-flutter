// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_vote_dao.dart';

// ignore_for_file: type=lint
mixin _$PollVoteDaoMixin on DatabaseAccessor<DriftChatDatabase> {
  $PollVotesTable get pollVotes => attachedDatabase.pollVotes;
  $UsersTable get users => attachedDatabase.users;
  PollVoteDaoManager get managers => PollVoteDaoManager(this);
}

class PollVoteDaoManager {
  final _$PollVoteDaoMixin _db;
  PollVoteDaoManager(this._db);
  $$PollVotesTableTableManager get pollVotes => $$PollVotesTableTableManager(_db.attachedDatabase, _db.pollVotes);
  $$UsersTableTableManager get users => $$UsersTableTableManager(_db.attachedDatabase, _db.users);
}
