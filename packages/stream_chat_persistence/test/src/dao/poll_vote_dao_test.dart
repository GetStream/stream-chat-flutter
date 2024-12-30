import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/poll_vote_dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late PollVoteDao pollVoteDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    pollVoteDao = database.pollVoteDao;
  });

  Future<List<PollVote>> _preparePollVoteData(
    String pollId, {
    String? userId,
    int count = 3,
  }) async {
    const options = [
      PollOption(id: 'option-1', text: 'Red'),
      PollOption(id: 'option-2', text: 'Blue'),
      PollOption(id: 'option-3', text: 'Green'),
    ];

    final latestVotesByOption = {
      for (final option in options)
        option.id!: [
          for (var i = 0; i < count; i++)
            PollVote(
              id: '${option.id}-pollVote-$i',
              pollId: pollId,
              userId: 'user-$i',
              user: User(id: 'user-$i', name: 'User $i'),
              optionId: option.id,
              createdAt: DateTime.now(),
            ),
        ],
    };

    final voteCountsByOption = latestVotesByOption.map(
      (key, value) => MapEntry(key, value.length),
    );

    final users = latestVotesByOption.values
        .expand((it) => it.map((it) => it.user!))
        .toList();

    final poll = Poll(
      id: pollId,
      name: 'testQuestion',
      createdById: userId ?? users.first.id,
      votingVisibility: VotingVisibility.anonymous,
      allowUserSuggestedOptions: true,
      options: options,
      voteCount: voteCountsByOption.values.reduce((a, b) => a + b),
      voteCountsByOption: voteCountsByOption,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      enforceUniqueVote: false,
      allowAnswers: true,
      extraData: const {'test_extra_data': 'extraData'},
    );

    final votes = latestVotesByOption.values.expand((it) => it).toList();

    await database.userDao.updateUsers(users);
    await database.pollDao.updatePolls([poll]);
    await pollVoteDao.updatePollVotes(votes);

    return votes;
  }

  test('getPollVotes', () async {
    const pollId = 'testPollId';

    // Should be empty initially
    final pollVotes = await pollVoteDao.getPollVotes(pollId);
    expect(pollVotes, isEmpty);

    // Adding sample poll votes
    final insertedPollVotes = await _preparePollVoteData(pollId);
    expect(insertedPollVotes, isNotEmpty);

    // Fetched pollVote length should match inserted pollVote length.
    // Every pollVote pollId should match the provided pollId.
    final fetchedPollVotes = await pollVoteDao.getPollVotes(pollId);
    expect(fetchedPollVotes.length, insertedPollVotes.length);
    expect(fetchedPollVotes.every((it) => it.pollId == pollId), true);
  });

  test('updatePollVotes', () async {
    const pollId = 'testPollId';

    // Preparing test data
    final pollVotes = await _preparePollVoteData(pollId);

    // Adding a new pollVote
    final newPollVote = PollVote(
      id: 'pollVote-4',
      pollId: pollId,
      userId: 'user-3',
      user: User(id: 'user-3', name: 'User 3'),
      optionId: 'option-4',
      createdAt: DateTime.now(),
    );

    await pollVoteDao.updatePollVotes([newPollVote]);

    // Fetched pollVote length should be one more than inserted pollVotes.
    // Fetched pollVote should contain the newPollVote.
    final fetchedPollVotes = await pollVoteDao.getPollVotes(pollId);
    expect(fetchedPollVotes.length, pollVotes.length + 1);
    expect(
      fetchedPollVotes.any((it) =>
          it.id == newPollVote.id &&
          it.pollId == newPollVote.pollId &&
          it.optionId == newPollVote.optionId &&
          it.answerText == newPollVote.answerText),
      true,
    );
  });

  group('deletePollVotesByPollIds', () {
    const pollId1 = 'testPollId1';
    const pollId2 = 'testPollId2';
    test('should delete all the pollVotes of first poll', () async {
      // Preparing test data
      final insertedPollVotes1 = await _preparePollVoteData(pollId1);
      final insertedPollVotes2 = await _preparePollVoteData(pollId2);

      // Fetched pollVote list length should match
      // the inserted pollVote list length
      final pollVotes1 = await pollVoteDao.getPollVotes(pollId1);
      final pollVotes2 = await pollVoteDao.getPollVotes(pollId2);
      expect(pollVotes1.length, insertedPollVotes1.length);
      expect(pollVotes2.length, insertedPollVotes2.length);

      // Deleting all the pollVotes of messageId1
      await pollVoteDao.deletePollVotesByPollIds([pollId1]);

      // Fetched pollVotes length of only pollId1 should be empty
      final fetchedPollVotes1 = await pollVoteDao.getPollVotes(pollId1);
      final fetchedPollVotes2 = await pollVoteDao.getPollVotes(pollId2);
      expect(fetchedPollVotes1, isEmpty);
      expect(fetchedPollVotes2, isNotEmpty);
    });

    test('should delete all the pollVotes of both polls', () async {
      // Preparing test data
      final insertedPollVotes1 = await _preparePollVoteData(pollId1);
      final insertedPollVotes2 = await _preparePollVoteData(pollId2);

      // Fetched pollVote list length should match
      // the inserted pollVote list length
      final pollVotes1 = await pollVoteDao.getPollVotes(pollId1);
      final pollVotes2 = await pollVoteDao.getPollVotes(pollId2);
      expect(pollVotes1.length, insertedPollVotes1.length);
      expect(pollVotes2.length, insertedPollVotes2.length);

      // Deleting all the pollVotes of messageId1
      await pollVoteDao.deletePollVotesByPollIds([pollId1, pollId2]);

      // Fetched pollVotes length of only pollId1 should be empty
      final fetchedPollVotes1 = await pollVoteDao.getPollVotes(pollId1);
      final fetchedPollVotes2 = await pollVoteDao.getPollVotes(pollId2);
      expect(fetchedPollVotes1, isEmpty);
      expect(fetchedPollVotes2, isEmpty);
    });
  });

  tearDown(() async {
    await database.disconnect();
  });
}
