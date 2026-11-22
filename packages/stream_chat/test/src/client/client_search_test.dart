import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  test(
    'StreamChatClient.search sends the query, sort and cursor and returns the results with their channels',
    () async {
      final payload = api.SearchPayload(
        filterConditions: _channelFilter().toJson(),
        query: 'hello',
        sort: const [api.SortParamRequest(field: 'created_at', direction: -1)],
        limit: 20,
        next: 'next-cursor',
      );

      final defaultApi = MockDefaultApi();
      when(() => defaultApi.search(payload: payload)).thenAnswer(
        (_) async => Result.success(
          api.SearchResponse(
            duration: '0.01ms',
            results: [api.SearchResult(message: generatedSearchResultMessage)],
            next: 'later-cursor',
            previous: 'earlier-cursor',
          ),
        ),
      );
      final client = _client(defaultApi);

      final res = await client.search(
        _channelFilter(),
        query: 'hello',
        sort: [MessageSearchSort.desc(MessageSearchSortField.createdAt)],
        limit: 20,
        next: 'next-cursor',
      );

      final response = res.getOrNull()!;
      final result = response.results.single;
      // A channel compares by identity, so it is checked on its own.
      expect(result.channel?.cid, 'messaging:general');
      expect(result.message.sharedLocation?.channel?.cid, 'messaging:general');
      expect(result.message.draft?.channel?.cid, 'messaging:general');
      expect(
        response,
        SearchMessagesResponse(
          duration: '0.01ms',
          results: [SearchMessageResult(message: expectedMessageLike(result.message), channel: result.channel)],
          next: 'later-cursor',
          previous: 'earlier-cursor',
        ),
      );
      verify(() => defaultApi.search(payload: payload)).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.search sends the message filters and offset and returns the results', () async {
    final messageFilter = Filter.equal(MessageSearchFilterField.pinned, true);
    final payload = api.SearchPayload(
      filterConditions: _channelFilter().toJson(),
      messageFilterConditions: messageFilter.toJson(),
      offset: 40,
    );

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.search(payload: payload),
    ).thenAnswer((_) async => const Result.success(api.SearchResponse(duration: '0.01ms', results: [])));
    final client = _client(defaultApi);

    final res = await client.search(_channelFilter(), messageFilters: messageFilter, offset: 40);

    expect(res.getOrNull(), const SearchMessagesResponse(duration: '0.01ms', results: []));
    verify(() => defaultApi.search(payload: payload)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.search leaves out a result without a message', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.search(
        payload: api.SearchPayload(filterConditions: _channelFilter().toJson(), query: 'hello'),
      ),
    ).thenAnswer(
      (_) async => const Result.success(api.SearchResponse(duration: '0.01ms', results: [api.SearchResult()])),
    );
    final client = _client(defaultApi);

    final res = await client.search(_channelFilter(), query: 'hello');

    expect(res.getOrNull(), const SearchMessagesResponse(duration: '0.01ms', results: []));
  });

  test('StreamChatClient.search returns a result without a channel when the message has none', () async {
    final message = api.SearchResultMessage.fromJson(generatedMessage.toJson());
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.search(
        payload: api.SearchPayload(filterConditions: _channelFilter().toJson(), query: 'hello'),
      ),
    ).thenAnswer(
      (_) async => Result.success(
        api.SearchResponse(
          duration: '0.01ms',
          results: [api.SearchResult(message: message)],
        ),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.search(_channelFilter(), query: 'hello');

    expect(res.getOrNull()!.results.single.channel, isNull);
  });

  test('StreamChatClient.search throws when neither a query nor message filters are given', () async {
    final client = _client(MockDefaultApi());

    await expectLater(client.search(_channelFilter()), throwsA(isA<ArgumentError>()));
  });

  test('StreamChatClient.search throws when both a query and message filters are given', () async {
    final client = _client(MockDefaultApi());

    await expectLater(
      client.search(
        _channelFilter(),
        query: 'hello',
        messageFilters: Filter.equal(MessageSearchFilterField.pinned, true),
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('StreamChatClient.search throws when an offset is combined with a sort', () async {
    final client = _client(MockDefaultApi());

    await expectLater(
      client.search(
        _channelFilter(),
        query: 'hello',
        sort: [MessageSearchSort.desc(MessageSearchSortField.createdAt)],
        offset: 10,
      ),
      throwsA(isA<AssertionError>()),
    );
  });

  test('StreamChatClient.search returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.search(
        payload: api.SearchPayload(filterConditions: _channelFilter().toJson(), query: 'hello'),
      ),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.search(_channelFilter(), query: 'hello');

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}

ChannelFilter _channelFilter() => Filter.in_(ChannelFilterField.cid, const ['messaging:general']);
