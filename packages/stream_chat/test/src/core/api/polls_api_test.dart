import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/polls_api.dart';
import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
    data: data,
    requestOptions: RequestOptions(path: path),
    statusCode: 200,
  );

  late final client = MockHttpClient();
  late PollsApi pollsApi;

  setUp(() {
    pollsApi = PollsApi(client);
  });

  test('createPoll', () async {
    final poll = Poll(
      id: 'test-poll-id',
      name: 'test-poll-name',
      options: const [
        PollOption(
          id: 'test-option-id',
          text: 'test-option-value',
        ),
      ],
    );

    const path = '/polls';

    when(
      () => client.post(
        path,
        data: jsonEncode(poll),
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'poll': poll.toJson(),
        },
      ),
    );

    final res = await pollsApi.createPoll(poll);

    expect(res, isNotNull);
    expect(res.poll.id, poll.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('getPoll', () async {
    const pollId = 'test-poll-id';

    const path = '/polls/$pollId';

    final poll = Poll(
      id: pollId,
      name: 'test-poll-name',
      options: const [
        PollOption(
          id: 'test-option-id',
          text: 'test-option-value',
        ),
      ],
    );

    when(() => client.get(path)).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'poll': poll.toJson(),
        },
      ),
    );

    final res = await pollsApi.getPoll(pollId);

    expect(res, isNotNull);
    expect(res.poll.id, pollId);

    verify(() => client.get(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('updatePoll', () async {
    final poll = Poll(
      id: 'test-poll-id',
      name: 'test-poll-name',
      options: const [
        PollOption(
          id: 'test-option-id',
          text: 'test-option-value',
        ),
      ],
    );

    const path = '/polls';

    when(
      () => client.put(
        path,
        data: jsonEncode(poll),
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'poll': poll.toJson(),
        },
      ),
    );

    final res = await pollsApi.updatePoll(poll);

    expect(res, isNotNull);
    expect(res.poll.id, poll.id);

    verify(() => client.put(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('partialUpdatePoll', () async {
    const pollId = 'test-poll-id';
    const set = {'name': 'updated-poll-name'};
    const unset = ['key'];

    const path = '/polls/$pollId';
    final poll = Poll(
      id: pollId,
      name: set['name']!,
      options: const [
        PollOption(
          id: 'test-option-id',
          text: 'test-option-value',
        ),
      ],
    );

    when(
      () => client.patch(
        path,
        data: jsonEncode({'set': set, 'unset': unset}),
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'poll': poll.toJson(),
        },
      ),
    );

    final res = await pollsApi.partialUpdatePoll(
      pollId,
      set: set,
      unset: unset,
    );

    expect(res, isNotNull);
    expect(res.poll.id, pollId);
    expect(res.poll.name, set['name']);

    verify(
      () => client.patch(
        path,
        data: jsonEncode({
          'set': set,
          'unset': unset,
        }),
      ),
    ).called(1);
    verifyNoMoreInteractions(client);
  });

  test('deletePoll', () async {
    const pollId = 'test-poll-id';

    const path = '/polls/$pollId';

    when(() => client.delete(path)).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await pollsApi.deletePoll(pollId);

    expect(res, isNotNull);

    verify(() => client.delete(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('createPollOption', () async {
    const pollId = 'test-poll-id';
    const option = PollOption(
      id: 'test-option-id',
      text: 'test-option-value',
    );

    const path = '/polls/$pollId/options';

    when(
      () => client.post(
        path,
        data: jsonEncode(option),
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'poll_option': option.toJson()
            ..addAll({
              'id': option.id,
            }),
        },
      ),
    );

    final res = await pollsApi.createPollOption(pollId, option);

    expect(res, isNotNull);
    expect(res.pollOption.id, option.id);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('getPollOption', () async {
    const pollId = 'test-poll-id';
    const optionId = 'test-option-id';

    const path = '/polls/$pollId/options/$optionId';

    const option = PollOption(
      id: optionId,
      text: 'test-option-value',
    );

    when(() => client.get(path)).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'poll_option': option.toJson()
            ..addAll({
              'id': option.id,
            }),
        },
      ),
    );

    final res = await pollsApi.getPollOption(pollId, optionId);

    expect(res, isNotNull);
    expect(res.pollOption.id, optionId);

    verify(() => client.get(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('updatePollOption', () async {
    const pollId = 'test-poll-id';
    const option = PollOption(
      id: 'test-option-id',
      text: 'test-option-value',
    );

    const path = '/polls/$pollId/options';

    when(
      () => client.put(
        path,
        data: jsonEncode(option),
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'poll_option': option.toJson()
            ..addAll({
              'id': option.id,
            }),
        },
      ),
    );

    final res = await pollsApi.updatePollOption(pollId, option);

    expect(res, isNotNull);
    expect(res.pollOption.id, option.id);

    verify(() => client.put(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('deletePollOption', () async {
    const pollId = 'test-poll-id';
    const optionId = 'test-option-id';

    const path = '/polls/$pollId/options/$optionId';

    when(() => client.delete(path)).thenAnswer((_) async => successResponse(path, data: <String, dynamic>{}));

    final res = await pollsApi.deletePollOption(pollId, optionId);

    expect(res, isNotNull);

    verify(() => client.delete(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('castPollVote', () async {
    const messageId = 'test-message-id';
    const pollId = 'test-poll-id';
    final vote = PollVote(
      pollId: 'test-poll-id',
      optionId: 'test-option-id',
    );

    const path = '/messages/$messageId/polls/$pollId/vote';

    when(
      () => client.post(
        path,
        data: jsonEncode({
          'vote': vote,
        }),
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'vote': vote.toJson(),
        },
      ),
    );

    final res = await pollsApi.castPollVote(messageId, pollId, vote);

    expect(res, isNotNull);
    expect(res.vote.optionId, vote.optionId);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('removePollVote', () async {
    const messageId = 'test-message-id';
    const pollId = 'test-poll-id';
    const voteId = 'test-vote-id';

    const path = '/messages/$messageId/polls/$pollId/vote/$voteId';
    final vote = PollVote(
      pollId: 'test-poll-id',
      optionId: 'test-option-id',
    );

    when(() => client.delete(path)).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'vote': vote.toJson(),
        },
      ),
    );

    final res = await pollsApi.removePollVote(messageId, pollId, voteId);

    expect(res, isNotNull);

    verify(() => client.delete(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('queryPolls', () async {
    const path = '/polls/query';
    final filter = Filter.in_('cid', const ['test-cid-1', 'test-cid-2']);
    const sort = [SortOption<Poll>.desc('test-field')];
    const pagination = PaginationParams(limit: 20);

    final payload = jsonEncode({
      'filter': filter,
      'sort': sort,
      ...pagination.toJson(),
    });

    final polls = List.generate(
      pagination.limit,
      (index) => Poll(
        id: 'test-poll-id=$index',
        name: 'test-poll-name=$index',
        options: [
          PollOption(
            id: 'test-option-id=$index',
            text: 'test-option-value=$index',
          ),
        ],
      ),
    );

    when(
      () => client.post(
        path,
        data: payload,
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'polls': [...polls.map((it) => it.toJson())],
        },
      ),
    );

    final res = await pollsApi.queryPolls(
      filter: filter,
      sort: sort,
      pagination: pagination,
    );

    expect(res, isNotNull);
    expect(res.polls, hasLength(polls.length));

    verify(
      () => client.post(path, data: any(named: 'data')),
    ).called(1);
    verifyNoMoreInteractions(client);
  });

  test('queryPollVotes', () async {
    const pollId = 'test-poll-id';
    final filter = Filter.in_('cid', const ['test-cid-1', 'test-cid-2']);
    const sort = [SortOption<PollVote>.desc('test-field')];
    const pagination = PaginationParams(limit: 20);

    const path = '/polls/$pollId/votes';

    final payload = jsonEncode({
      'filter': filter,
      'sort': sort,
      ...pagination.toJson(),
    });

    final votes = List.generate(
      pagination.limit,
      (index) => PollVote(
        pollId: pollId,
        optionId: 'test-option-id=$index',
      ),
    );

    when(
      () => client.post(
        path,
        data: payload,
      ),
    ).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'votes': [...votes.map((it) => it.toJson())],
        },
      ),
    );

    final res = await pollsApi.queryPollVotes(
      pollId,
      filter: filter,
      sort: sort,
      pagination: pagination,
    );

    expect(res, isNotNull);
    expect(res.votes, hasLength(votes.length));

    verify(
      () => client.post(path, data: any(named: 'data')),
    ).called(1);
    verifyNoMoreInteractions(client);
  });
}
