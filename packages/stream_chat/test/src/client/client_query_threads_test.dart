import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.QueryThreadsRequest()));

  test(
    'StreamChatClient.queryThreads sends the filter, sort, options, limit and cursor and returns the page',
    () async {
      const request = api.QueryThreadsRequest(
        filter: {
          'channel_cid': {r'$eq': 'messaging:general'},
        },
        sort: [api.SortParamRequest(field: 'last_message_at', direction: -1)],
        watch: false,
        replyLimit: 5,
        participantLimit: 20,
        memberLimit: 30,
        limit: 25,
        next: 'next-cursor',
      );

      final defaultApi = MockDefaultApi();
      when(() => defaultApi.queryThreads(queryThreadsRequest: request)).thenAnswer(
        (_) async => Result.success(
          api.QueryThreadsResponse(
            duration: '0.01ms',
            next: 'later-cursor',
            prev: 'earlier-cursor',
            threads: [generatedThread],
          ),
        ),
      );
      final client = _client(defaultApi);

      final res = await client.queryThreads(
        filter: ThreadFilter.equal(ThreadFilterField.channelCid, 'messaging:general'),
        sort: [ThreadSort.desc(ThreadSortField.lastMessageAt)],
        options: const ThreadOptions(watch: false, replyLimit: 5, participantLimit: 20, memberLimit: 30),
        limit: 25,
        next: 'next-cursor',
      );

      final response = res.getOrNull()!;
      final thread = response.threads.single;
      // A channel compares by identity, so it is checked on its own.
      expect([thread.channel?.cid, thread.draft?.channel?.cid], ['messaging:general', 'messaging:general']);
      expect(
        response,
        QueryThreadsResponse(
          duration: '0.01ms',
          threads: [expectedThreadLike(thread)],
          next: 'later-cursor',
          prev: 'earlier-cursor',
        ),
      );
      verify(() => defaultApi.queryThreads(queryThreadsRequest: request)).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.queryThreads sends the default options and limit and returns the empty page', () async {
    const request = api.QueryThreadsRequest(
      watch: true,
      replyLimit: 2,
      participantLimit: 10,
      memberLimit: 10,
      limit: 10,
    );

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryThreads(queryThreadsRequest: request),
    ).thenAnswer((_) async => const Result.success(api.QueryThreadsResponse(duration: '0.01ms', threads: [])));
    final client = _client(defaultApi);

    final res = await client.queryThreads();

    expect(res.getOrNull(), const QueryThreadsResponse(duration: '0.01ms', threads: []));
    verify(() => defaultApi.queryThreads(queryThreadsRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryThreads sends the previous-page cursor and returns the earlier page', () async {
    const request = api.QueryThreadsRequest(
      sort: [api.SortParamRequest(field: 'created_at', direction: 1)],
      watch: true,
      replyLimit: 2,
      participantLimit: 10,
      memberLimit: 10,
      limit: 10,
      prev: 'prev-cursor',
    );

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.queryThreads(queryThreadsRequest: request)).thenAnswer(
      (_) async => const Result.success(
        api.QueryThreadsResponse(duration: '0.01ms', next: 'prev-cursor', threads: []),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.queryThreads(sort: [ThreadSort.asc(ThreadSortField.createdAt)], prev: 'prev-cursor');

    expect(res.getOrNull(), const QueryThreadsResponse(duration: '0.01ms', threads: [], next: 'prev-cursor'));
    verify(() => defaultApi.queryThreads(queryThreadsRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryThreads returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryThreads(queryThreadsRequest: any(named: 'queryThreadsRequest')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.queryThreads();

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
