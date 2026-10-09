import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'message_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.QueryDraftsRequest()));

  test('StreamChatClient.queryDrafts sends the filter, sort, limit and cursor and returns the page', () async {
    const request = api.QueryDraftsRequest(
      filter: {
        'channel_cid': {r'$eq': 'messaging:general'},
      },
      sort: [api.SortParamRequest(field: 'created_at', direction: -1)],
      limit: 20,
      next: 'next-cursor',
    );

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.queryDrafts(queryDraftsRequest: request)).thenAnswer(
      (_) async => Result.success(
        api.QueryDraftsResponse(
          duration: '0.01ms',
          drafts: [generatedDraft],
          next: 'later-cursor',
          prev: 'earlier-cursor',
        ),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.queryDrafts(
      filter: DraftFilter.equal(DraftFilterField.channelCid, 'messaging:general'),
      sort: [DraftSort.desc(DraftSortField.createdAt)],
      limit: 20,
      next: 'next-cursor',
    );

    final response = res.getOrNull()!;
    final draft = response.drafts.single;
    // A channel compares by identity, so it is checked on its own.
    expect(draft.channel?.cid, 'messaging:general');
    expect(
      response,
      QueryDraftsResponse(
        duration: '0.01ms',
        drafts: [expectedDraft(attachmentId: draft.message.attachments.single.id, channel: draft.channel)],
        next: 'later-cursor',
        prev: 'earlier-cursor',
      ),
    );
    verify(() => defaultApi.queryDrafts(queryDraftsRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryDrafts sends no limit when none is given and returns the empty page', () async {
    const request = api.QueryDraftsRequest();

    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryDrafts(queryDraftsRequest: request),
    ).thenAnswer((_) async => const Result.success(api.QueryDraftsResponse(duration: '0.01ms', drafts: [])));
    final client = _client(defaultApi);

    final res = await client.queryDrafts();

    expect(res.getOrNull(), const QueryDraftsResponse(duration: '0.01ms', drafts: []));
    verify(() => defaultApi.queryDrafts(queryDraftsRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryDrafts sends the previous-page cursor and returns the earlier page', () async {
    const request = api.QueryDraftsRequest(prev: 'prev-cursor');

    final defaultApi = MockDefaultApi();
    when(() => defaultApi.queryDrafts(queryDraftsRequest: request)).thenAnswer(
      (_) async => const Result.success(api.QueryDraftsResponse(duration: '0.01ms', drafts: [], next: 'later-cursor')),
    );
    final client = _client(defaultApi);

    final res = await client.queryDrafts(prev: 'prev-cursor');

    expect(res.getOrNull(), const QueryDraftsResponse(duration: '0.01ms', drafts: [], next: 'later-cursor'));
    verify(() => defaultApi.queryDrafts(queryDraftsRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryDrafts returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryDrafts(queryDraftsRequest: any(named: 'queryDraftsRequest')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.queryDrafts();

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
