import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/db/query_utils.dart';
import 'package:stream_chat_persistence/src/entity/poll_votes.dart';
import 'package:stream_chat_persistence/src/entity/polls.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/poll_mapper.dart';
import 'package:stream_chat_persistence/src/mapper/user_mapper.dart';

part 'poll_dao.g.dart';

/// The Data Access Object for operations in [Polls] table.
@DriftAccessor(tables: [Polls, PollVotes, Users])
class PollDao extends DatabaseAccessor<DriftChatDatabase> with _$PollDaoMixin {
  /// Creates a new poll dao instance
  PollDao(this._db) : super(_db);

  final DriftChatDatabase _db;

  Future<Poll> _pollFromJoinRow(TypedResult row) async {
    final pollEntity = row.readTable(polls);
    final userEntity = row.readTable(users);
    final allVotes = await _db.pollVoteDao.getPollVotes(pollEntity.id);
    final latestAnswers = allVotes.where((it) => it.isAnswer);
    final ownVotesAndAnswers = allVotes.where((it) => it.userId == _db.userId);

    final latestVotesByOption = <String, List<PollVote>>{};
    for (final vote in allVotes) {
      if (vote.isAnswer) continue;
      if (vote.optionId case final optionId?) {
        latestVotesByOption.update(
          optionId,
          (value) => [...value, vote],
          ifAbsent: () => [vote],
        );
      }
    }

    return pollEntity.toPoll(
      createdBy: userEntity.toUser(),
      latestAnswers: latestAnswers.toList(),
      ownVotesAndAnswers: ownVotesAndAnswers.toList(),
      latestVotesByOption: latestVotesByOption,
    );
  }

  /// Returns the poll by matching [Polls.id] with [pollId]
  Future<Poll?> getPollById(String pollId) async => await (select(polls)..where((it) => it.id.equals(pollId)))
      .join([leftOuterJoin(users, polls.createdById.equalsExp(users.id))])
      .map(_pollFromJoinRow)
      .getSingleOrNull();

  /// Returns polls for every id in [pollIds], keyed by poll id.
  Future<Map<String, Poll?>> getPollsByIds(List<String> pollIds) async {
    if (pollIds.isEmpty) return const {};

    // Group votes once for every requested poll. The dense-map contract on
    // `getPollVotesForPolls` means every input id resolves to a (possibly
    // empty) list with a single lookup.
    final votesByPoll = await _db.pollVoteDao.getPollVotesForPolls(pollIds);

    final result = <String, Poll?>{for (final id in pollIds) id: null};
    for (final chunk in chunked(pollIds)) {
      final where = polls.id.isIn(chunk);
      final rows = await (select(polls)..where((_) => where)).join(
          [leftOuterJoin(users, polls.createdById.equalsExp(users.id))]).get();
      for (final row in rows) {
        final pollEntity = row.readTable(polls);
        // Same as `_pollFromJoinRow` => reads users via `readTable` (not
        // `readTableOrNull`) on a LEFT JOIN
        final userEntity = row.readTable(users);
        final allVotes = votesByPoll[pollEntity.id] ?? const <PollVote>[];
        result[pollEntity.id] = _buildPoll(pollEntity, userEntity, allVotes);
      }
    }
    return result;
  }

  /// Updates all the polls using the new [pollList] data
  Future<void> updatePolls(List<Poll> pollList) => batch(
    (it) => it.insertAllOnConflictUpdate(
      polls,
      pollList.map((it) => it.toEntity()),
    ),
  );

  /// Returns the list of all the polls stored in db
  Future<List<Poll>> getPolls() async => Future.wait(
    await (select(polls)..orderBy([(it) => OrderingTerm.desc(it.createdAt)]))
        .join([leftOuterJoin(users, polls.createdById.equalsExp(users.id))])
        .map(_pollFromJoinRow)
        .get(),
  );

  /// Deletes all the polls whose [Polls.id] is present in [pollIds]
  Future<void> deletePollsByIds(List<String> pollIds) => (delete(polls)..where((tbl) => tbl.id.isIn(pollIds))).go();

  Poll _buildPoll(
    PollEntity pollEntity,
    UserEntity userEntity,
    List<PollVote> allVotes,
  ) {
    final latestAnswers = allVotes.where((it) => it.isAnswer);
    final ownVotesAndAnswers = allVotes.where((it) => it.userId == _db.userId);

    final latestVotesByOption = <String, List<PollVote>>{};
    for (final vote in allVotes) {
      if (vote.isAnswer) continue;
      if (vote.optionId case final optionId?) {
        latestVotesByOption.update(
          optionId,
          (value) => [...value, vote],
          ifAbsent: () => [vote],
        );
      }
    }

    return pollEntity.toPoll(
      createdBy: userEntity.toUser(),
      latestAnswers: latestAnswers.toList(),
      ownVotesAndAnswers: ownVotesAndAnswers.toList(),
      latestVotesByOption: latestVotesByOption,
    );
  }
}
