import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateUsersPartialRequest(users: [])));

  test('StreamChatClient.updateUserPartial sends the set and unset fields and returns the updated users', () async {
    const request = api.UpdateUsersPartialRequest(
      users: [
        api.UpdateUserPartialRequest(id: 'user-id', set: {'favorite_color': 'green'}, unset: ['nickname']),
      ],
    );
    final defaultApi = _defaultApiAnswering(Result.success(_updateUsersResponse()));
    final client = _client(defaultApi);

    final res = await client.updateUserPartial(
      'user-id',
      set: const {'favorite_color': 'green'},
      unset: const ['nickname'],
    );

    expect(
      res.getOrNull(),
      UpdateUsersResponse(duration: '4.21ms', users: {'user-id': _updatedUser()}),
    );
    verify(() => defaultApi.updateUsersPartial(updateUsersPartialRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateUsersPartial sends every update and returns the updated users', () async {
    const request = api.UpdateUsersPartialRequest(
      users: [
        api.UpdateUserPartialRequest(id: 'first', set: {'a': 1}),
        api.UpdateUserPartialRequest(id: 'second', unset: ['b']),
      ],
    );
    final defaultApi = _defaultApiAnswering(Result.success(_updateUsersResponse()));
    final client = _client(defaultApi);

    final res = await client.updateUsersPartial(const [
      UpdateUserPartialRequest(id: 'first', set: {'a': 1}),
      UpdateUserPartialRequest(id: 'second', unset: ['b']),
    ]);

    expect(res.getOrNull(), UpdateUsersResponse(duration: '4.21ms', users: {'user-id': _updatedUser()}));
    verify(() => defaultApi.updateUsersPartial(updateUsersPartialRequest: request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateUserPartial returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final client = _client(_defaultApiAnswering(const Result.failure(error)));

    final res = await client.updateUserPartial('user-id', set: const {'a': 1});

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.updateUsersPartial returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final client = _client(_defaultApiAnswering(const Result.failure(error)));

    final res = await client.updateUsersPartial(const [
      UpdateUserPartialRequest(id: 'user-id', unset: ['a']),
    ]);

    expect(res.exceptionOrNull(), error);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}

MockDefaultApi _defaultApiAnswering(Result<api.UpdateUsersResponse> result) {
  final defaultApi = MockDefaultApi();
  when(
    () => defaultApi.updateUsersPartial(updateUsersPartialRequest: any(named: 'updateUsersPartialRequest')),
  ).thenAnswer((_) async => result);
  return defaultApi;
}

// The user [_updateUsersResponse] carries.
User _updatedUser() => User(
  id: 'user-id',
  role: 'admin',
  name: 'Updated Name',
  image: 'https://example.com/updated.png',
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
  extraData: const {'favorite_color': 'green'},
  deactivatedAt: DateTime.utc(2026, 9, 5),
  deletedAt: DateTime.utc(2026, 9, 6),
  shadowBanned: false,
);

// A response whose user sets every field, including the private ones a [User] leaves out.
api.UpdateUsersResponse _updateUsersResponse({
  Map<String, Object?> custom = const {'favorite_color': 'green'},
}) => api.UpdateUsersResponse(
  duration: '4.21ms',
  membershipDeletionTaskId: '',
  users: {
    'user-id': api.FullUserResponse(
      id: 'user-id',
      role: 'admin',
      name: 'Updated Name',
      image: 'https://example.com/updated.png',
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
      custom: custom,
      deactivatedAt: DateTime.utc(2026, 9, 5),
      deletedAt: DateTime.utc(2026, 9, 6),
      shadowBanned: false,
      revokeTokensIssuedBefore: DateTime.utc(2026, 9, 7),
      blockedUserIds: const ['blocked-user'],
      channelMutes: const [],
      devices: const [],
      mutes: const [],
      latestHiddenChannels: const ['messaging:hidden'],
      totalUnreadCount: 5,
      unreadChannels: 2,
      unreadCount: 4,
      unreadThreads: 1,
    ),
  },
);
