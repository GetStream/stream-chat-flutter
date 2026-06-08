import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/db/query_utils.dart';
import 'package:stream_chat_persistence/src/entity/poll_votes.dart';
import 'package:stream_chat_persistence/src/entity/polls.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/poll_vote_mapper.dart';
import 'package:stream_chat_persistence/src/mapper/user_mapper.dart';

part 'poll_vote_dao.g.dart';

/// The Data Access Object for operations in [Polls] table.
@DriftAccessor(tables: [PollVotes, Users])
class PollVoteDao extends DatabaseAccessor<DriftChatDatabase> with _$PollVoteDaoMixin {
  /// Creates a new poll vote dao instance
  PollVoteDao(super.db);

  /// Returns all the reactions of a particular message by matching
  /// [Reactions.messageId] with [messageId]
  Future<List<PollVote>> getPollVotes(String pollId) =>
      (select(pollVotes).join([
              leftOuterJoin(users, pollVotes.userId.equalsExp(users.id)),
            ])
            ..where(pollVotes.pollId.equals(pollId))
            ..orderBy([OrderingTerm.asc(pollVotes.createdAt)]))
          .map((rows) {
            final userEntity = rows.readTableOrNull(users);
            final pollVoteEntity = rows.readTable(pollVotes);
            return pollVoteEntity.toPollVote(user: userEntity?.toUser());
          })
          .get();

  /// Returns poll votes for every id in [pollIds], grouped by poll id.
  Future<Map<String, List<PollVote>>> getPollVotesForPolls(
    List<String> pollIds,
  ) async {
    if (pollIds.isEmpty) return const {};
    final grouped = <String, List<PollVote>>{
      for (final id in pollIds) id: <PollVote>[],
    };
    for (final chunk in chunked(pollIds)) {
      final where = pollVotes.pollId.isIn(chunk);
      final rows =
          await (select(pollVotes).join([
                  leftOuterJoin(users, pollVotes.userId.equalsExp(users.id)),
                ])
                ..where(where)
                ..orderBy([OrderingTerm.asc(pollVotes.createdAt)]))
              .map((row) {
                final userEntity = row.readTableOrNull(users);
                final pollVoteEntity = row.readTable(pollVotes);
                return pollVoteEntity.toPollVote(user: userEntity?.toUser());
              })
              .get();
      for (final v in rows) {
        grouped[v.pollId]!.add(v);
      }
    }
    return grouped;
  }

  /// Returns poll votes for every id in [pollIds], grouped by poll id.
  Future<Map<String, List<PollVote>>> getPollVotesForPolls(
    List<String> pollIds,
  ) async {
    if (pollIds.isEmpty) return const {};
    final grouped = <String, List<PollVote>>{
      for (final id in pollIds) id: <PollVote>[],
    };
    for (final chunk in chunked(pollIds)) {
      final where = pollVotes.pollId.isIn(chunk);
      final rows = await (select(pollVotes).join([
        leftOuterJoin(users, pollVotes.userId.equalsExp(users.id)),
      ])
            ..where(where)
            ..orderBy([OrderingTerm.asc(pollVotes.createdAt)]))
          .map((row) {
        final userEntity = row.readTableOrNull(users);
        final pollVoteEntity = row.readTable(pollVotes);
        return pollVoteEntity.toPollVote(user: userEntity?.toUser());
      }).get();
      for (final v in rows) {
        grouped[v.pollId]!.add(v);
      }
    }
    return grouped;
  }

  /// Updates the poll votes data with the new [pollVoteList] data
  Future<void> updatePollVotes(List<PollVote> pollVoteList) => batch(
    (it) => it.insertAllOnConflictUpdate(
      pollVotes,
      pollVoteList.map((it) => it.toEntity()),
    ),
  );

  /// Deletes all the poll votes whose [PollVote.pollId] is
  /// present in [pollIds]
  Future<void> deletePollVotesByPollIds(List<String> pollIds) =>
      (delete(pollVotes)..where((tbl) => tbl.pollId.isIn(pollIds))).go();
}
