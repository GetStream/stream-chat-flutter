import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'users_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateUsersRequest(users: {})));

  test(
    'StreamChatClient.updateUser sends the name, image, language, visibility and custom data and returns the updated '
    'users',
    () async {
      final defaultApi = _defaultApiAnswering(Result.success(updateUsersResponse()));
      final client = _client(defaultApi);

      final res = await client.updateUser(
        User(
          id: 'user-id',
          role: 'admin',
          name: 'Jane',
          image: 'https://example.com/jane.png',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 2),
          lastActive: DateTime.utc(2026, 1, 3),
          online: true,
          banned: true,
          banExpires: DateTime.utc(2026, 1, 4),
          teams: const ['team-a'],
          language: 'fr',
          invisible: true,
          teamsRole: const {'team-a': 'admin'},
          avgResponseTime: 12,
          custom: const {'favorite_color': 'blue'},
          deactivatedAt: DateTime.utc(2026, 1, 5),
          deletedAt: DateTime.utc(2026, 1, 6),
          shadowBanned: true,
        ),
      );

      expect(res.getOrNull(), UpdateUsersResponse(duration: '4.21ms', users: {'user-id': updatedUser()}));
      // `User` equality leaves these two out.
      expect(res.getOrNull()!.users['user-id']!.createdAt, DateTime.utc(2026, 9, 1));
      expect(res.getOrNull()!.users['user-id']!.updatedAt, DateTime.utc(2026, 9, 2));
      verify(
        () => defaultApi.updateUsers(
          updateUsersRequest: const api.UpdateUsersRequest(
            users: {
              'user-id': api.UserRequest(
                id: 'user-id',
                name: 'Jane',
                image: 'https://example.com/jane.png',
                language: 'fr',
                invisible: true,
                custom: {'favorite_color': 'blue'},
              ),
            },
          ),
        ),
      ).called(1);
      verifyNoMoreInteractions(defaultApi);
    },
  );

  test(
    'StreamChatClient.updateUser sends none of the fields an own user decodes from the connection as custom data',
    () async {
      final defaultApi = _defaultApiAnswering(Result.success(updateUsersResponse()));
      final client = _client(defaultApi);

      await client.updateUser(
        OwnUser.fromJson(const {
          'id': 'user-id',
          'favorite_color': 'blue',
          'unread_count': 3,
          'total_unread_count_by_team': {'team-a': 1},
          'latest_hidden_channels': ['messaging:hidden'],
        }),
      );

      verify(
        () => defaultApi.updateUsers(
          updateUsersRequest: const api.UpdateUsersRequest(
            users: {
              'user-id': api.UserRequest(id: 'user-id', custom: {'favorite_color': 'blue'}),
            },
          ),
        ),
      ).called(1);
    },
  );

  test('StreamChatClient.updateUsers sends every user keyed by id and returns the updated users', () async {
    final defaultApi = _defaultApiAnswering(Result.success(updateUsersResponse()));
    final client = _client(defaultApi);

    final res = await client.updateUsers([User(id: 'first', name: 'First'), User(id: 'second', name: 'Second')]);

    expect(res.getOrNull(), UpdateUsersResponse(duration: '4.21ms', users: {'user-id': updatedUser()}));
    verify(
      () => defaultApi.updateUsers(
        updateUsersRequest: const api.UpdateUsersRequest(
          users: {
            'first': api.UserRequest(id: 'first', name: 'First', custom: {}),
            'second': api.UserRequest(id: 'second', name: 'Second', custom: {}),
          },
        ),
      ),
    ).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test('StreamChatClient.updateUser returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final client = _client(_defaultApiAnswering(const Result.failure(error)));

    final res = await client.updateUser(User(id: 'user-id'));

    expect(res.exceptionOrNull(), error);
  });

  test('StreamChatClient.updateUsers returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final client = _client(_defaultApiAnswering(const Result.failure(error)));

    final res = await client.updateUsers([User(id: 'first'), User(id: 'second')]);

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
    () => defaultApi.updateUsers(updateUsersRequest: any(named: 'updateUsersRequest')),
  ).thenAnswer((_) async => result);
  return defaultApi;
}
