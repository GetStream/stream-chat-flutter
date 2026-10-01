import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'poll_fixtures.dart';

void main() {
  test('StreamChatClient.createPoll sends the poll settings and returns the created poll', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.createPoll(createPollRequest: any(named: 'createPollRequest')),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));
    final client = pollsClient(defaultApi);

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
          api.PollOptionInput(text: 'Pizza', custom: {'color': 'red'}),
          api.PollOptionInput(text: 'Sushi', custom: {}),
        ],
        votingVisibility: api.CreatePollRequestVotingVisibility.anonymous,
        enforceUniqueVote: false,
        maxVotesAllowed: 2,
        allowAnswers: true,
        allowUserSuggestedOptions: true,
        isClosed: false,
        custom: {'topic': 'food'},
      ),
    );
    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.createPoll returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.createPoll(createPollRequest: any(named: 'createPollRequest')),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.createPoll(_newPoll());

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.getPoll sends the poll id and returns the poll', () async {
    final defaultApi = pollsDefaultApi();
    when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(generatedPollResponse));
    final client = pollsClient(defaultApi);

    final result = await client.getPoll('poll-id');

    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.getPoll returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.getPoll('poll-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test(
    "StreamChatClient.getPoll keeps custom fields named like the poll's own fields out of its custom data",
    () async {
      final defaultApi = pollsDefaultApi();
      final response = api.PollResponse(
        duration: '4.21ms',
        poll: generatedPoll.copyWith(custom: const {'topic': 'food', 'name': 'custom-name', 'own_votes': 'custom'}),
      );
      when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));
      final client = pollsClient(defaultApi);

      final result = await client.getPoll('poll-id');

      expect(result.getOrNull()?.poll.extraData, const {'topic': 'food'});
    },
  );

  test('StreamChatClient.getPoll keeps a voting visibility the SDK does not name', () async {
    final defaultApi = pollsDefaultApi();
    final response = api.PollResponse(
      duration: '4.21ms',
      poll: generatedPoll.copyWith(votingVisibility: api.PollResponseDataVotingVisibility.fromJson('members_only')),
    );
    when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));
    final client = pollsClient(defaultApi);

    final result = await client.getPoll('poll-id');

    expect(result.getOrNull()?.poll.votingVisibility, const VotingVisibility('members_only'));
  });

  test('StreamChatClient.getPoll reads a poll that does not say whether it is closed as open', () async {
    final defaultApi = pollsDefaultApi();
    final response = api.PollResponse(duration: '4.21ms', poll: generatedPoll.copyWith(isClosed: null));
    when(() => defaultApi.getPoll(pollId: 'poll-id')).thenAnswer((_) async => Result.success(response));
    final client = pollsClient(defaultApi);

    final result = await client.getPoll('poll-id');

    expect(result.getOrNull()?.poll.isClosed, isFalse);
  });

  test('StreamChatClient.updatePoll sends the poll settings and options and returns the updated poll', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePoll(updatePollRequest: any(named: 'updatePollRequest')),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));
    final client = pollsClient(defaultApi);

    final result = await client.updatePoll(
      _newPoll().copyWith(
        options: const [
          PollOption(id: 'pizza', text: 'Pizza', extraData: {'color': 'red'}),
          PollOption(id: 'sushi', text: 'Sushi'),
        ],
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
          api.PollOptionRequest(id: 'pizza', text: 'Pizza', custom: {'color': 'red'}),
          api.PollOptionRequest(id: 'sushi', text: 'Sushi', custom: {}),
        ],
        votingVisibility: api.UpdatePollRequestVotingVisibility.anonymous,
        enforceUniqueVote: false,
        maxVotesAllowed: 2,
        allowAnswers: true,
        allowUserSuggestedOptions: true,
        isClosed: true,
        custom: {'topic': 'food'},
      ),
    );
    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.updatePoll sends an option without an id with an empty id', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePoll(updatePollRequest: any(named: 'updatePollRequest')),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));
    final client = pollsClient(defaultApi);

    await client.updatePoll(_newPoll().copyWith(options: const [PollOption(text: 'Pizza')]));

    final request =
        verify(
              () => defaultApi.updatePoll(updatePollRequest: captureAny(named: 'updatePollRequest')),
            ).captured.single
            as api.UpdatePollRequest;
    expect(request.options, const [api.PollOptionRequest(id: '', text: 'Pizza', custom: {})]);
  });

  test('StreamChatClient.updatePoll returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePoll(updatePollRequest: any(named: 'updatePollRequest')),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.updatePoll(poll);

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.partialUpdatePoll sends the fields to set and unset and returns the updated poll', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePollPartial(
        pollId: 'poll-id',
        updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'name': 'Dinner?'}, unset: ['description']),
      ),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));
    final client = pollsClient(defaultApi);

    final result = await client.partialUpdatePoll('poll-id', set: {'name': 'Dinner?'}, unset: ['description']);

    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.partialUpdatePoll returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePollPartial(
        pollId: 'poll-id',
        updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'name': 'Dinner?'}),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.partialUpdatePoll('poll-id', set: {'name': 'Dinner?'});

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.closePoll marks the poll closed and returns the closed poll', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePollPartial(
        pollId: 'poll-id',
        updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'is_closed': true}),
      ),
    ).thenAnswer((_) async => Result.success(generatedPollResponse));
    final client = pollsClient(defaultApi);

    final result = await client.closePoll('poll-id');

    expect(result, Result.success(pollResponse));
  });

  test('StreamChatClient.closePoll returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.updatePollPartial(
        pollId: 'poll-id',
        updatePollPartialRequest: const api.UpdatePollPartialRequest(set: {'is_closed': true}),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.closePoll('poll-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.deletePoll sends the poll id and returns a success', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.deletePoll(pollId: 'poll-id'),
    ).thenAnswer((_) async => const Result.success(api.DurationResponse(duration: '4.21ms')));
    final client = pollsClient(defaultApi);

    final result = await client.deletePoll('poll-id');

    expect(result, const Result<void>.success(null));
  });

  test('StreamChatClient.deletePoll returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(() => defaultApi.deletePoll(pollId: 'poll-id')).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.deletePoll('poll-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.queryPolls sends the filter, sort and cursor and returns the matching polls', () async {
    final defaultApi = pollsDefaultApi();
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
    final client = pollsClient(defaultApi);

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
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.queryPolls(queryPollsRequest: const api.QueryPollsRequest(limit: 10, prev: 'prev-cursor')),
    ).thenAnswer((_) async => const Result.success(api.QueryPollsResponse(duration: '4.21ms', polls: [])));
    final client = pollsClient(defaultApi);

    final result = await client.queryPolls(prev: 'prev-cursor');

    expect(result, const Result.success(QueryPollsResponse(duration: '4.21ms', polls: [])));
  });

  test('StreamChatClient.queryPolls returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.queryPolls(queryPollsRequest: const api.QueryPollsRequest(limit: 10)),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.queryPolls();

    expect(result.exceptionOrNull(), pollsApiError);
  });
}

// A poll as a caller builds it: options without ids and the vote summary at its defaults.
Poll _newPoll() => Poll(
  id: 'poll-id',
  name: 'Lunch?',
  description: 'Pick one',
  options: const [
    PollOption(text: 'Pizza', extraData: {'color': 'red'}),
    PollOption(text: 'Sushi'),
  ],
  votingVisibility: VotingVisibility.anonymous,
  enforceUniqueVote: false,
  maxVotesAllowed: 2,
  allowAnswers: true,
  allowUserSuggestedOptions: true,
  voteCount: 7,
  extraData: const {'topic': 'food'},
);
