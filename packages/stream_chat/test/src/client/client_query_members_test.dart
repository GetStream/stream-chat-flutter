import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  test(
    'StreamChatClient.queryMembers sends the channel, filter, sort and page and returns the matching members',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final res = await client.queryMembers(
        'messaging',
        channelId: 'general',
        filter: MemberFilter.equal(MemberFilterField.banned, true),
        sort: [MemberSort.desc(MemberSortField.createdAt)],
        pagination: PaginationParams(
          limit: 20,
          offset: 40,
          createdAtAfter: DateTime.utc(2026),
          createdAtAfterOrEqual: DateTime.utc(2026, 2),
          createdAtBefore: DateTime.utc(2026, 3),
          createdAtBeforeOrEqual: DateTime.utc(2026, 4),
        ),
      );

      expect(res, Result.success(QueryMembersResponse(duration: '0.01ms', members: [fakeChannelMember()])));
      verify(
        () => defaultApi.queryMembers(
          payload: api.QueryMembersPayload(
            type: 'messaging',
            id: 'general',
            filterConditions: const {
              'banned': {r'$eq': true},
            },
            sort: const [api.SortParamRequest(field: 'created_at', direction: -1)],
            limit: 20,
            offset: 40,
            createdAtAfter: DateTime.utc(2026),
            createdAtAfterOrEqual: DateTime.utc(2026, 2),
            createdAtBefore: DateTime.utc(2026, 3),
            createdAtBeforeOrEqual: DateTime.utc(2026, 4),
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test('StreamChatClient.queryMembers sends the members of a channel not created yet as user ids', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    await client.queryMembers(
      'messaging',
      members: [
        fakeChannelMember(),
        Member(userId: 'jo'),
      ],
    );

    verify(
      () => defaultApi.queryMembers(
        payload: const api.QueryMembersPayload(
          type: 'messaging',
          members: [
            api.ChannelMemberRequest(userId: 'member'),
            api.ChannelMemberRequest(userId: 'jo'),
          ],
          filterConditions: {},
        ),
      ),
    ).called(1);
  });

  test('StreamChatClient.queryMembers sends only the channel id when given members too', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    await client.queryMembers('messaging', channelId: 'general', members: [fakeChannelMember()]);

    verify(
      () => defaultApi.queryMembers(
        payload: const api.QueryMembersPayload(type: 'messaging', id: 'general', filterConditions: {}),
      ),
    ).called(1);
  });

  test('StreamChatClient.queryMembers leaves out the page fields members cannot be paged by', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    await client.queryMembers(
      'messaging',
      channelId: 'general',
      pagination: PaginationParams(
        next: 'next-page',
        idAround: 'member',
        greaterThan: 'a',
        greaterThanOrEqual: 'b',
        lessThan: 'y',
        lessThanOrEqual: 'z',
        createdAtAround: DateTime.utc(2026),
      ),
    );

    verify(
      () => defaultApi.queryMembers(
        payload: const api.QueryMembersPayload(type: 'messaging', id: 'general', filterConditions: {}, limit: 10),
      ),
    ).called(1);
  });

  test('StreamChatClient.queryMembers returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryMembers(payload: any(named: 'payload')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.queryMembers('messaging', channelId: 'general');

    expect(res.exceptionOrNull(), error);
  });
}

MockDefaultApi _defaultApi() {
  final defaultApi = MockDefaultApi();
  when(() => defaultApi.queryMembers(payload: any(named: 'payload'))).thenAnswer(
    (_) async => Result.success(api.MembersResponse(duration: '0.01ms', members: [fakeChannelMemberResponse()])),
  );
  return defaultApi;
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
