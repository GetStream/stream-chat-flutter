import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.QueryChannelsRequest()));

  test('StreamChatClient.queryChannelsOnline sends the filter, sort and page and returns the channels', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    final res = await client.queryChannelsOnline(
      filter: ChannelFilter.equal(ChannelFilterField.type, 'messaging'),
      sort: [ChannelSort.desc(ChannelSortField.lastMessageAt)],
      state: false,
      presence: true,
      memberLimit: 5,
      messageLimit: 10,
      waitForConnect: false,
      paginationParams: const PaginationParams(limit: 20, offset: 40),
    );

    expect(res.getOrNull()!.map((it) => it.cid), ['messaging:general']);
    verify(
      () => defaultApi.queryChannels(
        queryChannelsRequest: const api.QueryChannelsRequest(
          filterConditions: {
            'type': {r'$eq': 'messaging'},
          },
          sort: [api.SortParamRequest(field: 'last_message_at', direction: -1)],
          state: false,
          watch: false,
          presence: true,
          memberLimit: 5,
          messageLimit: 10,
          limit: 20,
          offset: 40,
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.queryChannelsOnline sends only the limit and offset of the page', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    await client.queryChannelsOnline(
      waitForConnect: false,
      paginationParams: PaginationParams(
        limit: 20,
        idAround: 'around-id',
        greaterThan: 'gt-id',
        lessThan: 'lt-id',
        createdAtAfter: DateTime.utc(2026),
        createdAtBefore: DateTime.utc(2026, 2),
      ),
    );

    verify(
      () => defaultApi.queryChannels(
        queryChannelsRequest: const api.QueryChannelsRequest(state: true, watch: false, presence: false, limit: 20),
      ),
    ).called(1);
  });

  test('StreamChatClient.queryChannelsOnline sends a predefined filter with its values', () async {
    final defaultApi = _defaultApi();
    final client = _client(defaultApi);

    await client.queryChannelsOnline(
      predefinedFilter: 'unread',
      filterValues: const {'user_id': 'mo'},
      sortValues: const {'field': 'last_message_at'},
      waitForConnect: false,
    );

    verify(
      () => defaultApi.queryChannels(
        queryChannelsRequest: const api.QueryChannelsRequest(
          predefinedFilter: 'unread',
          filterValues: {'user_id': 'mo'},
          sortValues: {'field': 'last_message_at'},
          state: true,
          watch: false,
          presence: false,
          limit: 10,
        ),
      ),
    ).called(1);
  });

  test('StreamChatClient.queryChannelsWithResult returns the predefined filter the query resolved to', () async {
    final defaultApi = _defaultApi(
      predefinedFilter: const api.ParsedPredefinedFilterResponse(
        name: 'unread',
        filter: {
          r'$or': [
            {
              'type': {r'$eq': 'messaging'},
            },
            {'frozen': false},
          ],
        },
        sort: [
          api.SortParamRequest(field: 'last_message_at', direction: -1),
          api.SortParamRequest(field: 'pinned_at', direction: 1),
        ],
      ),
    );
    final client = _client(defaultApi);

    final result = await client.queryChannelsWithResult(predefinedFilter: 'unread', waitForConnect: false).last;

    final predefinedFilter = result.predefinedFilter!;
    expect(predefinedFilter.name, 'unread');
    expect(predefinedFilter.filter.toJson(), {
      r'$or': [
        {
          'type': {r'$eq': 'messaging'},
        },
        {'frozen': false},
      ],
    });
    expect(
      [for (final sort in predefinedFilter.sort!) (sort.field.remote, sort.direction)],
      [
        ('last_message_at', SortDirection.desc),
        ('pinned_at', SortDirection.asc),
      ],
    );
  });

  test('StreamChatClient.queryChannelsWithResult drops a resolved sort without a field', () async {
    final sort = await _resolvedSort(const [
      api.SortParamRequest(field: 'last_message_at', direction: -1),
      api.SortParamRequest(direction: -1),
    ]);

    expect(sort.map((it) => it.field.remote), ['last_message_at']);
  });

  test('StreamChatClient.queryChannelsWithResult reads a resolved sort direction of 0 as ascending', () async {
    final sort = await _resolvedSort(const [api.SortParamRequest(field: 'some_custom_field', direction: 0)]);

    expect(sort.single.direction, SortDirection.asc);
  });

  test('StreamChatClient.queryChannelsOnline returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryChannels(queryChannelsRequest: any(named: 'queryChannelsRequest')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.queryChannelsOnline(waitForConnect: false);

    expect(res.exceptionOrNull(), error);
  });
}

// The sort of the predefined filter a query resolves to [sort].
Future<List<ChannelSort>> _resolvedSort(List<api.SortParamRequest> sort) async {
  final defaultApi = _defaultApi(
    predefinedFilter: api.ParsedPredefinedFilterResponse(name: 'unread', filter: const {}, sort: sort),
  );
  final client = _client(defaultApi);

  final result = await client.queryChannelsWithResult(predefinedFilter: 'unread', waitForConnect: false).last;

  return result.predefinedFilter!.sort!;
}

MockDefaultApi _defaultApi({api.ParsedPredefinedFilterResponse? predefinedFilter}) {
  final defaultApi = MockDefaultApi();
  when(() => defaultApi.queryChannels(queryChannelsRequest: any(named: 'queryChannelsRequest'))).thenAnswer(
    (_) async => Result.success(
      api.QueryChannelsResponse(
        duration: '0.01ms',
        channels: [
          api.ChannelStateResponseFields(
            channel: api.ChannelResponse(
              cid: 'messaging:general',
              id: 'general',
              type: 'messaging',
              createdAt: DateTime.utc(2026),
              updatedAt: DateTime.utc(2026),
              custom: const {},
              disabled: false,
              frozen: false,
            ),
            members: [fakeChannelMemberResponse()],
            messages: const [],
            pinnedMessages: const [],
            threads: const [],
          ),
        ],
        predefinedFilter: predefinedFilter,
      ),
    ),
  );
  return defaultApi;
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}
