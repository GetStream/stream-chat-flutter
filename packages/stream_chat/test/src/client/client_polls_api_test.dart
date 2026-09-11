import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  chatClientTest(
    '`.createPoll`',
    body: (tester) async {
      final poll = createDefaultPoll();

      tester.mockApi(
        (api) => api.polls.createPoll(poll),
        result: CreatePollResponse()..poll = poll,
      );

      final res = await tester.client.createPoll(poll);
      expect(res, isNotNull);
      expect(res.poll, poll);

      tester
        ..verifyApi((api) => api.polls.createPoll(poll))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.getPoll`',
    body: (tester) async {
      const pollId = 'test-poll-id';
      final poll = createDefaultPoll(id: pollId);

      tester.mockApi(
        (api) => api.polls.getPoll(pollId),
        result: GetPollResponse()..poll = poll,
      );

      final res = await tester.client.getPoll(pollId);
      expect(res, isNotNull);
      expect(res.poll, poll);

      tester
        ..verifyApi((api) => api.polls.getPoll(pollId))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.updatePoll`',
    body: (tester) async {
      final poll = createDefaultPoll(id: 'test-poll-id');

      tester.mockApi(
        (api) => api.polls.updatePoll(poll),
        result: createDefaultUpdatePollResponse(poll: poll),
      );

      final res = await tester.client.updatePoll(poll);
      expect(res, isNotNull);
      expect(res.poll, poll);

      tester
        ..verifyApi((api) => api.polls.updatePoll(poll))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.partialUpdatePoll`',
    body: (tester) async {
      const pollId = 'test-poll-id';
      final set = {'name': 'What is your favorite color?'};
      final unset = <String>[];

      final poll = createDefaultPoll(id: pollId, name: set['name']!);

      tester.mockApi(
        (api) => api.polls.partialUpdatePoll(pollId, set: set, unset: unset),
        result: createDefaultUpdatePollResponse(poll: poll),
      );

      final res = await tester.client.partialUpdatePoll(pollId, set: set, unset: unset);
      expect(res, isNotNull);
      expect(res.poll.id, pollId);
      expect(res.poll.name, set['name']);

      tester
        ..verifyApi((api) => api.polls.partialUpdatePoll(pollId, set: set, unset: unset))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.deletePoll`',
    body: (tester) async {
      const pollId = 'test-poll-id';

      tester.mockApi(
        (api) => api.polls.deletePoll(pollId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deletePoll(pollId);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.polls.deletePoll(pollId))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.closePoll`',
    body: (tester) async {
      const pollId = 'test-poll-id';

      tester.mockApi(
        (api) => api.polls.partialUpdatePoll(pollId, set: {'is_closed': true}),
        result: createDefaultUpdatePollResponse(),
      );

      final res = await tester.client.closePoll(pollId);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.polls.partialUpdatePoll(pollId, set: {'is_closed': true}))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.createPollOption`',
    body: (tester) async {
      const pollId = 'test-poll-id';
      final option = createDefaultPollOption();

      tester.mockApi(
        (api) => api.polls.createPollOption(pollId, option),
        result: CreatePollOptionResponse()..pollOption = option,
      );

      final res = await tester.client.createPollOption(pollId, option);
      expect(res, isNotNull);
      expect(res.pollOption, option);

      tester
        ..verifyApi((api) => api.polls.createPollOption(pollId, option))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.getPollOption`',
    body: (tester) async {
      const pollId = 'test-poll-id';
      const optionId = 'test-option-id';
      final option = createDefaultPollOption(id: optionId);

      tester.mockApi(
        (api) => api.polls.getPollOption(pollId, optionId),
        result: GetPollOptionResponse()..pollOption = option,
      );

      final res = await tester.client.getPollOption(pollId, optionId);
      expect(res, isNotNull);
      expect(res.pollOption, option);

      tester
        ..verifyApi((api) => api.polls.getPollOption(pollId, optionId))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.updatePollOption`',
    body: (tester) async {
      const pollId = 'test-poll-id';
      final option = createDefaultPollOption(id: 'test-option-id');

      tester.mockApi(
        (api) => api.polls.updatePollOption(pollId, option),
        result: UpdatePollOptionResponse()..pollOption = option,
      );

      final res = await tester.client.updatePollOption(pollId, option);
      expect(res, isNotNull);
      expect(res.pollOption, option);

      tester
        ..verifyApi((api) => api.polls.updatePollOption(pollId, option))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.deletePollOption`',
    body: (tester) async {
      const pollId = 'test-poll-id';
      const optionId = 'test-option-id';

      tester.mockApi(
        (api) => api.polls.deletePollOption(pollId, optionId),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.client.deletePollOption(pollId, optionId);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.polls.deletePollOption(pollId, optionId))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.castPollVote`',
    body: (tester) async {
      const messageId = 'test-message-id';
      const pollId = 'test-poll-id';
      const optionId = 'test-option-id';
      final vote = createDefaultPollVote(optionId: optionId);

      // Custom matcher to check if the Vote object has the specified id
      Matcher matchesVoteOption(String expected) => predicate<PollVote>(
        (vote) => vote.optionId == expected,
        'Vote with option $expected',
      );

      tester.mockApi(
        (api) => api.polls.castPollVote(messageId, pollId, any(that: matchesVoteOption(optionId))),
        result: createDefaultCastPollVoteResponse(vote: vote),
      );

      final res = await tester.client.castPollVote(messageId, pollId, optionId: optionId);
      expect(res, isNotNull);
      expect(res.vote, vote);

      tester
        ..verifyApi((api) => api.polls.castPollVote(messageId, pollId, any(that: matchesVoteOption(optionId))))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.addPollAnswer`',
    body: (tester) async {
      const messageId = 'test-message-id';
      const pollId = 'test-poll-id';
      const answerText = 'Red';
      final vote = createDefaultPollVote(answerText: answerText);

      // Custom matcher to check if the Vote object has the specified id
      Matcher matchesVoteAnswer(String expected) => predicate<PollVote>(
        (vote) => vote.answerText == expected,
        'Vote with answer $expected',
      );

      tester.mockApi(
        (api) => api.polls.castPollVote(messageId, pollId, any(that: matchesVoteAnswer(answerText))),
        result: createDefaultCastPollVoteResponse(vote: vote),
      );

      final res = await tester.client.addPollAnswer(messageId, pollId, answerText: answerText);
      expect(res, isNotNull);
      expect(res.vote, vote);

      tester
        ..verifyApi((api) => api.polls.castPollVote(messageId, pollId, any(that: matchesVoteAnswer(answerText))))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.removePollVote`',
    body: (tester) async {
      const messageId = 'test-message-id';
      const pollId = 'test-poll-id';
      const voteId = 'test-vote-id';

      tester.mockApi(
        (api) => api.polls.removePollVote(messageId, pollId, voteId),
        result: RemovePollVoteResponse(),
      );

      final res = await tester.client.removePollVote(messageId, pollId, voteId);
      expect(res, isNotNull);

      tester
        ..verifyApi((api) => api.polls.removePollVote(messageId, pollId, voteId))
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.queryPolls`',
    body: (tester) async {
      final filter = Filter.in_('id', const ['test-poll-id']);
      final sort = [const SortOption<Poll>.desc('created_at')];
      const pagination = PaginationParams(limit: 20);

      final polls = List.generate(
        pagination.limit,
        (index) => createDefaultPoll(id: 'test-poll-id-$index'),
      );

      tester.mockApi(
        (api) => api.polls.queryPolls(
          filter: filter,
          sort: sort,
          pagination: pagination,
        ),
        result: QueryPollsResponse()..polls = polls,
      );

      final res = await tester.client.queryPolls(
        filter: filter,
        sort: sort,
        pagination: pagination,
      );
      expect(res, isNotNull);
      expect(res.polls.length, polls.length);

      tester
        ..verifyApi(
          (api) => api.polls.queryPolls(
            filter: filter,
            sort: sort,
            pagination: pagination,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );

  chatClientTest(
    '`.queryPollVotes`',
    body: (tester) async {
      const pollId = 'test-poll-id';
      final filter = Filter.in_('id', const ['test-vote-id']);
      final sort = [const SortOption<PollVote>.desc('created_at')];
      const pagination = PaginationParams(limit: 20);

      final votes = List.generate(
        pagination.limit,
        (index) => createDefaultPollVote(id: 'test-vote-id-$index', answerText: 'Red'),
      );

      tester.mockApi(
        (api) => api.polls.queryPollVotes(
          pollId,
          filter: filter,
          sort: sort,
          pagination: pagination,
        ),
        result: QueryPollVotesResponse()..votes = votes,
      );

      final res = await tester.client.queryPollVotes(
        pollId,
        filter: filter,
        sort: sort,
        pagination: pagination,
      );
      expect(res, isNotNull);
      expect(res.votes.length, votes.length);

      tester
        ..verifyApi(
          (api) => api.polls.queryPollVotes(
            pollId,
            filter: filter,
            sort: sort,
            pagination: pagination,
          ),
        )
        ..verifyNoMoreApiInteractions((api) => api.polls);
    },
  );
}
