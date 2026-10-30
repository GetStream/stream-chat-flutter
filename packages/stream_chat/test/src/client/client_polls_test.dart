import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'poll_fixtures.dart';

void main() {
  late MockDefaultApi defaultApi;
  late StreamChatClient client;

  setUpAll(() {
    registerFallbackValue(const api.CreatePollRequest(name: 'fallback'));
    registerFallbackValue(const api.UpdatePollRequest(id: 'fallback', name: 'fallback'));
    registerFallbackValue(const api.CreatePollOptionRequest(text: 'fallback'));
    registerFallbackValue(const api.UpdatePollOptionRequest(id: 'fallback', text: 'fallback'));
  });

  setUp(() {
    defaultApi = MockDefaultApi();
    client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  });

  test('StreamChatClient.createPoll sends the poll settings and returns the created poll', () async {
    when(
      () => defaultApi.createPoll(createPollRequest: any(named: 'createPollRequest')),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));

    final result = await client.createPoll(_newPoll());

    final request = verify(
      () => defaultApi.createPoll(createPollRequest: captureAny(named: 'createPollRequest')),
    ).captured.single;
    expect(
      request,
      const api.CreatePollRequest(
        id: 'poll-id',
        name: 'Lunch?',
        description: 'Pick one',
        options: [
          api.PollOptionInput(text: 'Pizza', custom: {'color': 'red', 'text': 'Pasta'}),
          api.PollOptionInput(text: 'Sushi', custom: {}),
        ],
        votingVisibility: api.VotingVisibility.anonymous,
        enforceUniqueVote: false,
        maxVotesAllowed: 2,
        allowAnswers: true,
        allowUserSuggestedOptions: true,
        isClosed: false,
        custom: {'topic': 'food', 'name': 'Dinner?'},
      ),
    );
    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.createPoll returns the failure without throwing', () async {
    when(
      () => defaultApi.createPoll(createPollRequest: any(named: 'createPollRequest')),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.createPoll(_newPoll());

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.getPoll sends the poll id and returns the poll', () async {
    when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(generatedPollResponse));

    final result = await client.getPoll('poll-id');

    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.getPoll returns the failure without throwing', () async {
    when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.getPoll('poll-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test(
    "StreamChatClient.getPoll keeps a custom field named like one of the poll's own fields",
    () async {
      final response = api.PollResponse(
        duration: '4.21ms',
        poll: generatedPoll.copyWith(custom: const {'topic': 'food', 'name': 'custom-name', 'own_votes': 'custom'}),
      );
      when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));

      final result = await client.getPoll('poll-id');

      expect(result.getOrNull()?.poll.custom, const {
        'topic': 'food',
        'name': 'custom-name',
        'own_votes': 'custom',
      });
    },
  );

  test('StreamChatClient.getPoll keeps a voting visibility the SDK does not name', () async {
    final response = api.PollResponse(
      duration: '4.21ms',
      poll: generatedPoll.copyWith(votingVisibility: const api.VotingVisibility('members_only')),
    );
    when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));

    final result = await client.getPoll('poll-id');

    expect(result.getOrNull()?.poll.votingVisibility, const VotingVisibility('members_only'));
  });

  test("StreamChatClient.getPoll reads someone else's vote in an anonymous poll without a user", () async {
    final response = api.PollResponse(
      duration: '4.21ms',
      poll: generatedPoll.copyWith(
        latestVotesByOption: {
          'pizza': [generatedVote.copyWith(userId: null, user: null)],
        },
      ),
    );
    when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));

    final result = await client.getPoll('poll-id');

    final pizzaVote = result.getOrNull()?.poll.latestVotesByOption['pizza']?.single;
    expect((pizzaVote?.userId, pizzaVote?.user), (null, null));
  });

  test('StreamChatClient.getPoll reads a poll that does not say whether it is closed as open', () async {
    final response = api.PollResponse(duration: '4.21ms', poll: generatedPoll.copyWith(isClosed: null));
    when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));

    final result = await client.getPoll('poll-id');

    expect(result.getOrNull()?.poll.isClosed, isFalse);
  });

  test('StreamChatClient.updatePoll sends the poll settings and options and returns the updated poll', () async {
    when(
      () => defaultApi.updatePoll(updatePollRequest: any(named: 'updatePollRequest')),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));

    final result = await client.updatePoll(
      _newPoll().copyWith(
        options: const [
          PollOption(id: 'pizza', text: 'Pizza', custom: {'color': 'red', 'id': 'pasta'}),
          PollOption(id: 'sushi', text: 'Sushi'),
        ],
        votingVisibility: const VotingVisibility('members_only'),
        isClosed: true,
      ),
    );

    final request = verify(
      () => defaultApi.updatePoll(updatePollRequest: captureAny(named: 'updatePollRequest')),
    ).captured.single;
    expect(
      request,
      const api.UpdatePollRequest(
        id: 'poll-id',
        name: 'Lunch?',
        description: 'Pick one',
        options: [
          api.PollOptionRequest(id: 'pizza', text: 'Pizza', custom: {'color': 'red', 'id': 'pasta'}),
          api.PollOptionRequest(id: 'sushi', text: 'Sushi', custom: {}),
        ],
        votingVisibility: api.VotingVisibility('members_only'),
        enforceUniqueVote: false,
        maxVotesAllowed: 2,
        allowAnswers: true,
        allowUserSuggestedOptions: true,
        isClosed: true,
        custom: {'topic': 'food', 'name': 'Dinner?'},
      ),
    );
    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.updatePoll sends an option without an id with an empty id', () async {
    when(
      () => defaultApi.updatePoll(updatePollRequest: any(named: 'updatePollRequest')),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));

    await client.updatePoll(_newPoll().copyWith(options: const [PollOption(text: 'Pizza')]));

    final request =
        verify(
              () => defaultApi.updatePoll(updatePollRequest: captureAny(named: 'updatePollRequest')),
            ).captured.single
            as api.UpdatePollRequest;
    expect(request.options, const [api.PollOptionRequest(id: '', text: 'Pizza', custom: {})]);
  });

  test('StreamChatClient.updatePoll returns the failure without throwing', () async {
    when(
      () => defaultApi.updatePoll(updatePollRequest: any(named: 'updatePollRequest')),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.updatePoll(poll);

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.partialUpdatePoll sends the fields to set and unset and returns the updated poll', () async {
    when(
      () => defaultApi.updatePollPartial(
        pollId: 'poll-id',
        updatePollPartialRequest: const api.UpdatePollPartialRequest(
          set: {'name': 'Dinner?'},
          unset: ['description'],
        ),
      ),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));

    final result = await client.partialUpdatePoll('poll-id', set: {'name': 'Dinner?'}, unset: ['description']);

    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.partialUpdatePoll returns the failure without throwing', () async {
    when(
      () => defaultApi.updatePollPartial(
        pollId: 'poll-id',
        updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'name': 'Dinner?'}),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.partialUpdatePoll('poll-id', set: {'name': 'Dinner?'});

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.closePoll marks the poll closed and returns the closed poll', () async {
    when(
      () => defaultApi.updatePollPartial(
        pollId: 'poll-id',
        updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'is_closed': true}),
      ),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));

    final result = await client.closePoll('poll-id');

    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.closePoll returns the failure without throwing', () async {
    when(
      () => defaultApi.updatePollPartial(
        pollId: 'poll-id',
        updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'is_closed': true}),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.closePoll('poll-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.deletePoll sends the poll id and returns a success', () async {
    when(
      () => defaultApi.deletePoll(pollId: 'poll-id'),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '4.21ms')));

    final result = await client.deletePoll('poll-id');

    expect(result, const Result<void>.success(null));
  });

  test('StreamChatClient.deletePoll returns the failure without throwing', () async {
    when(() => defaultApi.deletePoll(pollId: 'poll-id')).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.deletePoll('poll-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.queryPolls sends the filter, sort and cursor and returns the matching polls', () async {
    when(
      () => defaultApi.queryPolls(
        queryPollsRequest: const api.QueryPollsRequest(
          filter: {
            'is_closed': {r'$eq': true},
          },
          sort: [api.SortParamRequest(field: 'created_at', direction: -1)],
          limit: 10,
          next: 'next-cursor',
        ),
      ),
    ).thenAnswer(
      (_) async => Result.success(
        api.QueryPollsResponse(duration: '4.21ms', polls: [generatedPoll], next: 'after', prev: 'before'),
      ),
    );

    final result = await client.queryPolls(
      filter: Filter.equal(PollFilterField.isClosed, true),
      sort: [PollSort.desc(PollSortField.createdAt)],
      limit: 10,
      next: 'next-cursor',
    );

    expect(
      result,
      Result.success(QueryPollsResponse(duration: '4.21ms', polls: [poll], next: 'after', prev: 'before')),
    );
  });

  test('StreamChatClient.queryPolls sends the previous-page cursor and ten as the default limit', () async {
    when(
      () => defaultApi.queryPolls(queryPollsRequest: const api.QueryPollsRequest(limit: 10, prev: 'prev-cursor')),
    ).thenAnswer((_) async => const Result.success(api.QueryPollsResponse(duration: '4.21ms', polls: [])));

    final result = await client.queryPolls(prev: 'prev-cursor');

    expect(result, const Result.success(QueryPollsResponse(duration: '4.21ms', polls: [])));
  });

  test('StreamChatClient.queryPolls returns the failure without throwing', () async {
    when(
      () => defaultApi.queryPolls(queryPollsRequest: const api.QueryPollsRequest(limit: 10)),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.queryPolls();

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test(
    'StreamChatClient.createPollOption sends the option text and custom data and returns the created option',
    () async {
      when(
        () => defaultApi.createPollOption(
          pollId: 'poll-id',
          createPollOptionRequest: const api.CreatePollOptionRequest(
            text: 'Pizza',
            custom: {'color': 'red', 'text': 'Pasta'},
          ),
        ),
      ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));

      final result = await client.createPollOption(
        'poll-id',
        const PollOption(text: 'Pizza', custom: {'color': 'red', 'text': 'Pasta'}),
      );

      expect(result, const Result.success(_pizzaResponse));
    },
  );

  test('StreamChatClient.createPollOption returns the failure without throwing', () async {
    when(
      () => defaultApi.createPollOption(
        pollId: 'poll-id',
        createPollOptionRequest: any(named: 'createPollOptionRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.createPollOption('poll-id', const PollOption(text: 'Pizza'));

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.getPollOption sends the poll and option ids and returns the option', () async {
    when(
      () => defaultApi.getPollOption(pollId: 'poll-id', optionId: 'pizza'),
    ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));

    final result = await client.getPollOption('poll-id', 'pizza');

    expect(result, const Result.success(_pizzaResponse));
  });

  test('StreamChatClient.getPollOption returns the failure without throwing', () async {
    when(
      () => defaultApi.getPollOption(pollId: 'poll-id', optionId: 'pizza'),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.getPollOption('poll-id', 'pizza');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test(
    "StreamChatClient.getPollOption keeps a custom field named like one of the option's own fields",
    () async {
      final response = api.PollOptionResponse(
        duration: '4.21ms',
        pollOption: generatedPizza.copyWith(custom: const {'color': 'red', 'text': 'custom-text'}),
      );
      when(
        () => defaultApi.getPollOption(pollId: 'poll-id', optionId: 'pizza'),
      ).thenAnswer((_) async => Result.success(response));

      final result = await client.getPollOption('poll-id', 'pizza');

      expect(result.getOrNull()?.pollOption.custom, const {'color': 'red', 'text': 'custom-text'});
    },
  );

  test('StreamChatClient.updatePollOption sends the option and returns the updated option', () async {
    when(
      () => defaultApi.updatePollOption(
        pollId: 'poll-id',
        updatePollOptionRequest: const api.UpdatePollOptionRequest(
          id: 'pizza',
          text: 'Pizza',
          custom: {'color': 'red'},
        ),
      ),
    ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));

    final result = await client.updatePollOption('poll-id', pizza);

    expect(result, const Result.success(_pizzaResponse));
  });

  test('StreamChatClient.updatePollOption sends an option without an id with an empty id', () async {
    when(
      () => defaultApi.updatePollOption(
        pollId: 'poll-id',
        updatePollOptionRequest: const api.UpdatePollOptionRequest(id: '', text: 'Pizza', custom: {}),
      ),
    ).thenAnswer((_) async => const Result.success(_generatedPizzaResponse));

    final result = await client.updatePollOption('poll-id', const PollOption(text: 'Pizza'));

    expect(result, const Result.success(_pizzaResponse));
  });

  test('StreamChatClient.updatePollOption returns the failure without throwing', () async {
    when(
      () => defaultApi.updatePollOption(
        pollId: 'poll-id',
        updatePollOptionRequest: any(named: 'updatePollOptionRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.updatePollOption('poll-id', pizza);

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.deletePollOption sends the poll and option ids and returns a success', () async {
    when(
      () => defaultApi.deletePollOption(pollId: 'poll-id', optionId: 'pizza'),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '4.21ms')));

    final result = await client.deletePollOption('poll-id', 'pizza');

    expect(result, const Result<void>.success(null));
  });

  test('StreamChatClient.deletePollOption returns the failure without throwing', () async {
    when(
      () => defaultApi.deletePollOption(pollId: 'poll-id', optionId: 'pizza'),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.deletePollOption('poll-id', 'pizza');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.castPollVote sends the selected option and returns the cast vote', () async {
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(optionId: 'pizza')),
      ),
    ).thenAnswer(
      (_) async => Result.success(api.PollVoteResponse(duration: '4.21ms', poll: generatedPoll, vote: generatedVote)),
    );

    final result = await client.castPollVote('message-id', 'poll-id', optionId: 'pizza');

    expect(result, Result.success(PollVoteResponse(duration: '4.21ms', vote: vote)));
  });

  test('StreamChatClient.castPollVote returns the failure without throwing', () async {
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(optionId: 'pizza')),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.castPollVote('message-id', 'poll-id', optionId: 'pizza');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.castPollVote returns no vote when the response carries none', () async {
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(optionId: 'pizza')),
      ),
    ).thenAnswer((_) async => const Result.success(api.PollVoteResponse(duration: '4.21ms')));

    final result = await client.castPollVote('message-id', 'poll-id', optionId: 'pizza');

    expect(result, const Result.success(PollVoteResponse(duration: '4.21ms')));
  });

  test('StreamChatClient.addPollAnswer sends the answer text and returns the answer', () async {
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(answerText: 'Anything')),
      ),
    ).thenAnswer(
      (_) async => Result.success(api.PollVoteResponse(duration: '4.21ms', poll: generatedPoll, vote: generatedAnswer)),
    );

    final result = await client.addPollAnswer('message-id', 'poll-id', answerText: 'Anything');

    expect(result, Result.success(PollVoteResponse(duration: '4.21ms', vote: answer)));
  });

  test('StreamChatClient.addPollAnswer returns the failure without throwing', () async {
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(answerText: 'Anything')),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.addPollAnswer('message-id', 'poll-id', answerText: 'Anything');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.removePollVote sends the vote id and returns the removed vote', () async {
    when(
      () => defaultApi.deletePollVote(messageId: 'message-id', pollId: 'poll-id', voteId: 'vote-id'),
    ).thenAnswer(
      (_) async => Result.success(api.PollVoteResponse(duration: '4.21ms', poll: generatedPoll, vote: generatedVote)),
    );

    final result = await client.removePollVote('message-id', 'poll-id', 'vote-id');

    expect(result, Result.success(PollVoteResponse(duration: '4.21ms', vote: vote)));
  });

  test('StreamChatClient.removePollVote returns the failure without throwing', () async {
    when(
      () => defaultApi.deletePollVote(messageId: 'message-id', pollId: 'poll-id', voteId: 'vote-id'),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.removePollVote('message-id', 'poll-id', 'vote-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.queryPollVotes sends the filter, sort and cursor and returns the matching votes', () async {
    when(
      () => defaultApi.queryPollVotes(
        pollId: 'poll-id',
        queryPollVotesRequest: const api.QueryPollVotesRequest(
          filter: {
            'is_answer': {r'$eq': true},
          },
          sort: [api.SortParamRequest(field: 'created_at', direction: 1)],
          limit: 25,
          next: 'next-cursor',
        ),
      ),
    ).thenAnswer(
      (_) async => Result.success(
        api.PollVotesResponse(duration: '4.21ms', votes: [generatedVote, generatedAnswer], next: 'after', prev: 'x'),
      ),
    );

    final result = await client.queryPollVotes(
      'poll-id',
      filter: Filter.equal(PollVoteFilterField.isAnswer, true),
      sort: [PollVoteSort.asc(PollVoteSortField.createdAt)],
      limit: 25,
      next: 'next-cursor',
    );

    expect(
      result,
      Result.success(QueryPollVotesResponse(duration: '4.21ms', votes: [vote, answer], next: 'after', prev: 'x')),
    );
  });

  test('StreamChatClient.queryPollVotes returns the failure without throwing', () async {
    when(
      () => defaultApi.queryPollVotes(
        pollId: 'poll-id',
        queryPollVotesRequest: const api.QueryPollVotesRequest(limit: 10),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));

    final result = await client.queryPollVotes('poll-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.queryPollVotes sends the previous-page cursor and ten as the default limit', () async {
    when(
      () => defaultApi.queryPollVotes(
        pollId: 'poll-id',
        queryPollVotesRequest: const api.QueryPollVotesRequest(limit: 10, prev: 'prev-cursor'),
      ),
    ).thenAnswer((_) async => const Result.success(api.PollVotesResponse(duration: '4.21ms', votes: [])));

    final result = await client.queryPollVotes('poll-id', prev: 'prev-cursor');

    expect(result, const Result.success(QueryPollVotesResponse(duration: '4.21ms', votes: [])));
  });
}

// A poll as a caller builds it: options without ids and the vote summary at its defaults.
Poll _newPoll() => Poll(
  id: 'poll-id',
  name: 'Lunch?',
  description: 'Pick one',
  options: const [
    PollOption(text: 'Pizza', custom: {'color': 'red', 'text': 'Pasta'}),
    PollOption(text: 'Sushi'),
  ],
  votingVisibility: VotingVisibility.anonymous,
  enforceUniqueVote: false,
  maxVotesAllowed: 2,
  allowAnswers: true,
  allowUserSuggestedOptions: true,
  voteCount: 7,
  // Custom data named like one of the poll's own fields is sent as custom data.
  custom: const {'topic': 'food', 'name': 'Dinner?'},
);

const _generatedPizzaResponse = api.PollOptionResponse(duration: '4.21ms', pollOption: generatedPizza);

const _pizzaResponse = PollOptionResponse(duration: '4.21ms', pollOption: pizza);
