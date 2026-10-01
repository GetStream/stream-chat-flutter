import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'poll_fixtures.dart';

void main() {
  test('StreamChatClient.castPollVote sends the selected option and returns the cast vote', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(optionId: 'pizza')),
      ),
    ).thenAnswer(
      (_) async => Result.success(api.PollVoteResponse(duration: '4.21ms', poll: generatedPoll, vote: generatedVote)),
    );
    final client = pollsClient(defaultApi);

    final result = await client.castPollVote('message-id', 'poll-id', optionId: 'pizza');

    expect(result, Result.success(PollVoteResponse(duration: '4.21ms', vote: vote)));
  });

  test('StreamChatClient.castPollVote returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(optionId: 'pizza')),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.castPollVote('message-id', 'poll-id', optionId: 'pizza');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.castPollVote returns no vote when the response carries none', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(optionId: 'pizza')),
      ),
    ).thenAnswer((_) async => const Result.success(api.PollVoteResponse(duration: '4.21ms')));
    final client = pollsClient(defaultApi);

    final result = await client.castPollVote('message-id', 'poll-id', optionId: 'pizza');

    expect(result, const Result.success(PollVoteResponse(duration: '4.21ms')));
  });

  test('StreamChatClient.addPollAnswer sends the answer text and returns the answer', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(answerText: 'Anything')),
      ),
    ).thenAnswer(
      (_) async => Result.success(api.PollVoteResponse(duration: '4.21ms', poll: generatedPoll, vote: generatedAnswer)),
    );
    final client = pollsClient(defaultApi);

    final result = await client.addPollAnswer('message-id', 'poll-id', answerText: 'Anything');

    expect(result, Result.success(PollVoteResponse(duration: '4.21ms', vote: answer)));
  });

  test('StreamChatClient.addPollAnswer returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.castPollVote(
        messageId: 'message-id',
        pollId: 'poll-id',
        castPollVoteRequest: const api.CastPollVoteRequest(vote: api.VoteData(answerText: 'Anything')),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.addPollAnswer('message-id', 'poll-id', answerText: 'Anything');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.removePollVote sends the vote id and returns the removed vote', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.deletePollVote(messageId: 'message-id', pollId: 'poll-id', voteId: 'vote-id'),
    ).thenAnswer(
      (_) async => Result.success(api.PollVoteResponse(duration: '4.21ms', poll: generatedPoll, vote: generatedVote)),
    );
    final client = pollsClient(defaultApi);

    final result = await client.removePollVote('message-id', 'poll-id', 'vote-id');

    expect(result, Result.success(PollVoteResponse(duration: '4.21ms', vote: vote)));
  });

  test('StreamChatClient.removePollVote returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.deletePollVote(messageId: 'message-id', pollId: 'poll-id', voteId: 'vote-id'),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.removePollVote('message-id', 'poll-id', 'vote-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.queryPollVotes sends the filter, sort and cursor and returns the matching votes', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.queryPollVotes(
        pollId: 'poll-id',
        queryPollVotesRequest: const api.QueryPollVotesRequest(
          filter: {
            'is_answer': {r'$eq': true},
          },
          sort: [api.SortParamRequest(field: 'created_at', direction: 1)],
          limit: 25,
          prev: 'prev-cursor',
        ),
      ),
    ).thenAnswer(
      (_) async => Result.success(
        api.PollVotesResponse(duration: '4.21ms', votes: [generatedVote, generatedAnswer], next: 'after', prev: 'x'),
      ),
    );
    final client = pollsClient(defaultApi);

    final result = await client.queryPollVotes(
      'poll-id',
      filter: Filter.equal(PollVoteFilterField.isAnswer, true),
      sort: [PollVoteSort.asc(PollVoteSortField.createdAt)],
      limit: 25,
      prev: 'prev-cursor',
    );

    expect(
      result,
      Result.success(QueryPollVotesResponse(duration: '4.21ms', votes: [vote, answer], next: 'after', prev: 'x')),
    );
  });

  test('StreamChatClient.queryPollVotes returns the failure without throwing', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.queryPollVotes(
        pollId: 'poll-id',
        queryPollVotesRequest: const api.QueryPollVotesRequest(limit: 10),
      ),
    ).thenAnswer((_) async => const Result.failure(pollsApiError));
    final client = pollsClient(defaultApi);

    final result = await client.queryPollVotes('poll-id');

    expect(result.exceptionOrNull(), pollsApiError);
  });

  test('StreamChatClient.queryPollVotes sends ten as the default limit', () async {
    final defaultApi = pollsDefaultApi();
    when(
      () => defaultApi.queryPollVotes(
        pollId: 'poll-id',
        queryPollVotesRequest: const api.QueryPollVotesRequest(limit: 10),
      ),
    ).thenAnswer((_) async => const Result.success(api.PollVotesResponse(duration: '4.21ms', votes: [])));
    final client = pollsClient(defaultApi);

    final result = await client.queryPollVotes('poll-id');

    expect(result, const Result.success(QueryPollVotesResponse(duration: '4.21ms', votes: [])));
  });
}
