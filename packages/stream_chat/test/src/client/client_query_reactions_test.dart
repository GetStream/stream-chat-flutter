import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.QueryReactionsRequest()));

  test('StreamChatClient.queryReactions sends the filter, sort, limit and cursor and returns the page', () async {
    const request = api.QueryReactionsRequest(
      filter: {
        'type': {r'$eq': 'love'},
      },
      sort: [api.SortParamRequest(field: 'created_at', direction: -1)],
      limit: 20,
      next: 'next-cursor',
    );

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.queryReactions(id: 'message-id', queryReactionsRequest: request)).thenAnswer(
      (_) async => Result.success(
        api.QueryReactionsResponse(
          duration: '0.01ms',
          reactions: [generatedReaction],
          next: 'later-cursor',
          prev: 'earlier-cursor',
        ),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.queryReactions(
      'message-id',
      filter: ReactionFilter.equal(ReactionFilterField.type, 'love'),
      sort: [ReactionSort.desc(ReactionSortField.createdAt)],
      limit: 20,
      next: 'next-cursor',
    );

    expect(
      res.getOrNull(),
      QueryReactionsResponse(
        duration: '0.01ms',
        reactions: [expectedReaction],
        next: 'later-cursor',
        prev: 'earlier-cursor',
      ),
    );
    verify(() => defaultApi.queryReactions(id: 'message-id', queryReactionsRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryReactions sends no limit when none is given and returns the empty page', () async {
    const request = api.QueryReactionsRequest();

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.queryReactions(id: 'message-id', queryReactionsRequest: request)).thenAnswer(
      (_) async => const Result.success(api.QueryReactionsResponse(duration: '0.01ms', reactions: [])),
    );
    final client = _client(defaultApi);

    final res = await client.queryReactions('message-id');

    expect(res.getOrNull(), const QueryReactionsResponse(duration: '0.01ms', reactions: []));
    verify(() => defaultApi.queryReactions(id: 'message-id', queryReactionsRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryReactions sends the previous-page cursor and returns the earlier page', () async {
    const request = api.QueryReactionsRequest(prev: 'prev-cursor');

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.queryReactions(id: 'message-id', queryReactionsRequest: request)).thenAnswer(
      (_) async =>
          const Result.success(api.QueryReactionsResponse(duration: '0.01ms', reactions: [], next: 'later-cursor')),
    );
    final client = _client(defaultApi);

    final res = await client.queryReactions('message-id', prev: 'prev-cursor');

    expect(res.getOrNull(), const QueryReactionsResponse(duration: '0.01ms', reactions: [], next: 'later-cursor'));
    verify(() => defaultApi.queryReactions(id: 'message-id', queryReactionsRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryReactions returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryReactions(
        id: 'message-id',
        queryReactionsRequest: any(named: 'queryReactionsRequest'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.queryReactions('message-id');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
