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

  test('updatePolls', () async {
    // Preparing test data
    final insertedPolls = await _preparePollData();

    // Adding a new poll
    final newPoll = insertedPolls.first.copyWith(id: 'newPollId');

    await pollDao.updatePolls([newPoll]);

    // Fetched poll should match the newly inserted poll.
    final fetchedPoll = await pollDao.getPollById(newPoll.id);
    expect(fetchedPoll, isNotNull);
    expect(fetchedPoll!.id, newPoll.id);
  });

  test('getPollById', () async {
    // Preparing test data
    final insertedPolls = await _preparePollData();

    // Fetched poll should not be null
    final pollToFetch = insertedPolls.first;
    final fetchedPoll = await pollDao.getPollById(pollToFetch.id);
    expect(fetchedPoll!.id, pollToFetch.id);
  });

  test('deletePollsByIds', () async {
    // Preparing test data
    final insertedPolls = await _preparePollData();

    // Deleting the first poll
    final pollToDelete = insertedPolls.first;
    await pollDao.deletePollsByIds([pollToDelete.id]);

    // Fetched poll should be null.
    final fetchedPoll = await pollDao.getPollById(pollToDelete.id);
    expect(fetchedPoll, isNull);
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

    // Fetched poll should be null.
    final fetchedPoll = await pollDao.getPollById(pollToDelete.id);
    expect(fetchedPoll, isNull);

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
