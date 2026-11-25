import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test(
    'StreamChatClient.queryUsers sends the filter, sort, presence and page and returns the matching users',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      final res = await client.queryUsers(
        presence: true,
        filter: UserFilter.in_(UserFilterField.id, const ['first-user', 'second-user']),
        sort: [UserSort.desc(UserSortField.createdAt)],
        pagination: const PaginationParams(
          limit: 20,
          offset: 40,
          greaterThan: 'a',
          greaterThanOrEqual: 'b',
          lessThan: 'y',
          lessThanOrEqual: 'z',
        ),
      );

      expect(res, Result.success(QueryUsersResponse(duration: '4.21ms', users: _users())));
      verify(
        () => defaultApi.queryUsers(
          payload: const api.QueryUsersPayload(
            filterConditions: {
              'id': {
                r'$in': ['first-user', 'second-user'],
              },
            },
            presence: true,
            sort: [api.SortParamRequest(field: 'created_at', direction: -1)],
            limit: 20,
            offset: 40,
            idGt: 'a',
            idGte: 'b',
            idLt: 'y',
            idLte: 'z',
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test(
    'StreamChatClient.queryUsers sends an empty filter and turns presence off when the client is not connected',
    () async {
      final defaultApi = _defaultApi();
      final client = _client(defaultApi);

      await client.queryUsers();

      verify(
        () => defaultApi.queryUsers(
          payload: const api.QueryUsersPayload(filterConditions: {}, presence: false),
        ),
      ).called(1);
    },
  );

  test('StreamChatClient.queryUsers stores the users it returns in the client state', () async {
    final client = _client(_defaultApi());

    await client.queryUsers();

    expect(client.state.users, {for (final user in _users()) user.id: user});
  });

  test('StreamChatClient.queryUsers returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryUsers(payload: any(named: 'payload')),
    ).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.queryUsers();

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.queryUsers leaves the users in the client state unchanged when it fails', () async {
    final defaultApi = MockDefaultApi();
    when(
      () => defaultApi.queryUsers(payload: any(named: 'payload')),
    ).thenAnswer((_) async => const Result.failure(StreamClientException(message: 'boom')));
    final client = _client(defaultApi);
    client.state.updateUsers([User(id: 'kept')]);

    await client.queryUsers();

    expect(client.state.users, {'kept': User(id: 'kept')});
  });
}

MockDefaultApi _defaultApi() {
  final defaultApi = MockDefaultApi();
  when(() => defaultApi.queryUsers(payload: any(named: 'payload'))).thenAnswer(
    (_) async => Result.success(api.QueryUsersResponse(duration: '4.21ms', users: _userResponses())),
  );
  return defaultApi;
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}

// Every field a [User] maps is set to a value that is not its default, and the
// two users differ in each, so a field the mapping drops or swaps changes the
// compared users.
List<User> _users() => [
  User(
    id: 'first-user',
    role: 'admin',
    name: 'First User',
    image: 'https://example.com/first.png',
    createdAt: DateTime.utc(2026, 9, 1),
    updatedAt: DateTime.utc(2026, 9, 2),
    lastActive: DateTime.utc(2026, 9, 3),
    online: true,
    banned: true,
    banExpires: DateTime.utc(2026, 9, 4),
    teams: const ['team-a'],
    language: 'de',
    invisible: false,
    teamsRole: const {'team-a': 'member'},
    avgResponseTime: 42,
    custom: const {'favorite_color': 'green'},
    deactivatedAt: DateTime.utc(2026, 9, 5),
    deletedAt: DateTime.utc(2026, 9, 6),
    shadowBanned: false,
    blockedUserIds: const ['blocked-first'],
  ),
  User(
    id: 'second-user',
    role: 'moderator',
    name: 'Second User',
    image: 'https://example.com/second.png',
    createdAt: DateTime.utc(2026, 10, 1),
    updatedAt: DateTime.utc(2026, 10, 2),
    lastActive: DateTime.utc(2026, 10, 3),
    online: false,
    banned: false,
    banExpires: DateTime.utc(2026, 10, 4),
    teams: const ['team-b', 'team-c'],
    language: 'fr',
    invisible: true,
    teamsRole: const {'team-b': 'owner'},
    avgResponseTime: 7,
    custom: const {'favorite_color': 'blue'},
    deactivatedAt: DateTime.utc(2026, 10, 5),
    deletedAt: DateTime.utc(2026, 10, 6),
    shadowBanned: true,
    blockedUserIds: const ['blocked-second'],
  ),
];

List<api.FullUserResponse> _userResponses() => [
  api.FullUserResponse(
    id: 'first-user',
    role: 'admin',
    name: 'First User',
    image: 'https://example.com/first.png',
    createdAt: DateTime.utc(2026, 9, 1),
    updatedAt: DateTime.utc(2026, 9, 2),
    lastActive: DateTime.utc(2026, 9, 3),
    online: true,
    banned: true,
    banExpires: DateTime.utc(2026, 9, 4),
    teams: const ['team-a'],
    language: 'de',
    invisible: false,
    teamsRole: const {'team-a': 'member'},
    avgResponseTime: 42,
    custom: const {'favorite_color': 'green'},
    deactivatedAt: DateTime.utc(2026, 9, 5),
    deletedAt: DateTime.utc(2026, 9, 6),
    shadowBanned: false,
    blockedUserIds: const ['blocked-first'],
    channelMutes: const [],
    devices: const [],
    mutes: const [],
    totalUnreadCount: 0,
    unreadChannels: 0,
    unreadCount: 0,
    unreadThreads: 0,
  ),
  api.FullUserResponse(
    id: 'second-user',
    role: 'moderator',
    name: 'Second User',
    image: 'https://example.com/second.png',
    createdAt: DateTime.utc(2026, 10, 1),
    updatedAt: DateTime.utc(2026, 10, 2),
    lastActive: DateTime.utc(2026, 10, 3),
    online: false,
    banned: false,
    banExpires: DateTime.utc(2026, 10, 4),
    teams: const ['team-b', 'team-c'],
    language: 'fr',
    invisible: true,
    teamsRole: const {'team-b': 'owner'},
    avgResponseTime: 7,
    custom: const {'favorite_color': 'blue'},
    deactivatedAt: DateTime.utc(2026, 10, 5),
    deletedAt: DateTime.utc(2026, 10, 6),
    shadowBanned: true,
    blockedUserIds: const ['blocked-second'],
    channelMutes: const [],
    devices: const [],
    mutes: const [],
    totalUnreadCount: 0,
    unreadChannels: 0,
    unreadCount: 0,
    unreadThreads: 0,
  ),
];
