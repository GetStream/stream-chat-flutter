import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late PollDao pollDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    pollDao = database.pollDao;
  });

  List<PollVote> _expandPollVotes(Poll poll) {
    final latestAnswers = poll.latestAnswers;
    final latestVotes = poll.latestVotesByOption.values;
    final ownVotesAndAnswers = poll.ownVotesAndAnswers;
    return [
      ...latestAnswers,
      ...latestVotes.expand((it) => it),
      ...ownVotesAndAnswers,
    ];
  }

  Future<List<Poll>> _preparePollData({int count = 3}) async {
    final polls = <Poll>[];

    for (var i = 0; i < count; i++) {
      final pollId = 'poll-$i';

      final createdBy = User(id: 'user-$i', name: 'User $i');

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
                id: 'pollVote-$i',
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

      final poll = Poll(
        id: pollId,
        name: 'testQuestion',
        createdBy: createdBy,
        createdById: createdBy.id,
        options: options,
        latestVotesByOption: latestVotesByOption,
        voteCount: voteCountsByOption.values.reduce((a, b) => a + b),
        voteCountsByOption: voteCountsByOption,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        enforceUniqueVote: false,
        extraData: const {'test_extra_data': 'extraData'},
      );

      polls.add(poll);
    }

    final users = polls.map((it) => it.createdBy!).toList();
    final pollVotes = polls.expand(_expandPollVotes).toList();

    await database.userDao.updateUsers(users);
    await pollDao.updatePolls(polls);
    await database.pollVoteDao.updatePollVotes(pollVotes);

    return polls;
  }

  test('getPolls', () async {
    // Should be empty initially
    final polls = await pollDao.getPolls();
    expect(polls, isEmpty);

    // Adding sample polls
    final insertedPolls = await _preparePollData();
    expect(insertedPolls, isNotEmpty);

    // Fetched polls length should match inserted polls length.
    final fetchedPollVotes = await pollDao.getPolls();
    expect(fetchedPollVotes.length, insertedPolls.length);
  });

  test('updatePolls', () async {
    // Preparing test data
    final insertedPolls = await _preparePollData();

    // Adding a new poll
    final newPoll = insertedPolls.first.copyWith(id: 'newPollId');

    await pollDao.updatePolls([newPoll]);

    // Fetched users length should be one more than inserted users.
    // Fetched users should contain the newUser.
    final fetchedPolls = await pollDao.getPolls();
    expect(fetchedPolls.length, insertedPolls.length + 1);
    expect(fetchedPolls.any((it) => it.id == newPoll.id), isTrue);
  });

  test('getPollById', () async {
    // Preparing test data
    final insertedPolls = await _preparePollData();

    // Fetched poll should not be null
    final pollToFetch = insertedPolls.first;
    final fetchedPoll = await pollDao.getPollById(pollToFetch.id);
    expect(fetchedPoll!.id, pollToFetch.id);
  });

  test('getPollById returns null for an unknown id', () async {
    final poll = await pollDao.getPollById('does-not-exist');
    expect(poll, isNull);
  });

  test(
      'getPollById hydrates ownVotesAndAnswers + latestVotesByOption + '
      'latestAnswers from mixed-user/mixed-option votes', () async {
    const pollId = 'poll-mixed';
    const optionA = PollOption(id: 'opt-a', text: 'A');
    const optionB = PollOption(id: 'opt-b', text: 'B');

    // The test database is built with `testUserId`, so a vote with that
    // userId is "own". Other userIds end up only in the latest-by-option
    // / latest-answers buckets.
    final dbUser = User(id: 'testUserId');
    final otherUser = User(id: 'otherUser');
    await database.userDao.updateUsers([dbUser, otherUser]);
    await pollDao.updatePolls([
      Poll(
        id: pollId,
        name: 'Pick one',
        options: const [optionA, optionB],
        createdBy: dbUser,
        createdById: dbUser.id,
      ),
    ]);
    await database.pollVoteDao.updatePollVotes([
      PollVote(
        id: 'own-vote-a',
        pollId: pollId,
        userId: dbUser.id,
        user: dbUser,
        optionId: optionA.id,
        createdAt: DateTime.now(),
      ),
      PollVote(
        id: 'other-vote-b',
        pollId: pollId,
        userId: otherUser.id,
        user: otherUser,
        optionId: optionB.id,
        createdAt: DateTime.now().add(const Duration(seconds: 1)),
      ),
      PollVote(
        id: 'own-answer',
        pollId: pollId,
        userId: dbUser.id,
        user: dbUser,
        answerText: 'because',
        createdAt: DateTime.now().add(const Duration(seconds: 2)),
      ),
      PollVote(
        id: 'other-answer',
        pollId: pollId,
        userId: otherUser.id,
        user: otherUser,
        answerText: 'just because',
        createdAt: DateTime.now().add(const Duration(seconds: 3)),
      ),
    ]);

    final fetched = await pollDao.getPollById(pollId);

    expect(fetched, isNotNull);
    expect(fetched!.latestVotesByOption[optionA.id], hasLength(1));
    expect(fetched.latestVotesByOption[optionB.id], hasLength(1));
    expect(fetched.latestAnswers, hasLength(2));
    // 1 own vote + 1 own answer => 2.
    expect(fetched.ownVotesAndAnswers, hasLength(2));
    expect(
      fetched.ownVotesAndAnswers.every((v) => v.userId == dbUser.id),
      isTrue,
    );
  });

  test('deletePollsByIds', () async {
    // Preparing test data
    final insertedPolls = await _preparePollData();

    // Deleting the first poll
    final pollToDelete = insertedPolls.first;
    await pollDao.deletePollsByIds([pollToDelete.id]);

    // Fetched poll list should be one less than inserted polls.
    final fetchedPolls = await pollDao.getPolls();
    expect(fetchedPolls.length, insertedPolls.length - 1);
    expect(fetchedPolls.any((it) => it.id == pollToDelete.id), isFalse);
  });

  test('deleting a poll should also delete its votes', () async {
    // Preparing test data
    final insertedPolls = await _preparePollData();

    // Verify that the poll has votes
    final pollToDelete = insertedPolls.first;
    final pollVotes = await database.pollVoteDao.getPollVotes(pollToDelete.id);
    expect(pollVotes, isNotEmpty);

    // Delete the poll
    await pollDao.deletePollsByIds([pollToDelete.id]);

    // Fetched poll list should be one less than inserted polls.
    final fetchedPolls = await pollDao.getPolls();
    expect(fetchedPolls.length, insertedPolls.length - 1);
    expect(fetchedPolls.any((it) => it.id == pollToDelete.id), isFalse);

    // Fetched poll votes should be empty
    final fetchedPollVotes = await database.pollVoteDao.getPollVotes(
      pollToDelete.id,
    );
    expect(fetchedPollVotes, isEmpty);
  });

  tearDown(() async {
    await database.disconnect();
  });
}
