import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/api/user_api.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  Response successResponse(String path, {Object? data}) => Response(
        data: data,
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  late final client = MockHttpClient();
  late UserApi userApi;

  setUp(() {
    userApi = UserApi(client);
  });

  test('queryUsers', () async {
    const presence = true;
    final filter = Filter.in_('cid', const ['test-cid-1', 'test-cid-2']);
    const sort = [SortOption<User>.desc('test-field')];
    const pagination = PaginationParams();

    const path = '/users';

    final users = List.generate(3, (index) => User(id: 'test-user-id-$index'));

    when(() => client.get(path, queryParameters: {
          'payload': jsonEncode({
            'presence': presence,
            'sort': sort,
            'filter_conditions': filter,
            ...pagination.toJson(),
          }),
        })).thenAnswer((_) async => successResponse(path, data: {
          'users': [...users.map((it) => it.toJson())]
        }));

    final res = await userApi.queryUsers(
      presence: presence,
      filter: filter,
      sort: sort,
      pagination: pagination,
    );

    expect(res, isNotNull);
    expect(res.users.length, users.length);

    verify(
      () => client.get(path, queryParameters: any(named: 'queryParameters')),
    ).called(1);
    verifyNoMoreInteractions(client);
  });

  test('updateUsers', () async {
    final users = List.generate(3, (index) => User(id: 'test-user-id-$index'));

    const path = '/users';

    final updatedUsers = {for (final user in users) user.id: user};

    when(() => client.post(path, data: {
          'users': updatedUsers,
        })).thenAnswer((_) async => successResponse(path,
            data: {
              'users': updatedUsers
                  .map((key, value) => MapEntry(key, value.toJson()))
            }));

    final res = await userApi.updateUsers(users);

    expect(res, isNotNull);
    expect(res.users.length, updatedUsers.length);

    verify(() => client.post(path, data: any(named: 'data'))).called(1);
    verifyNoMoreInteractions(client);
  });

  test('partialUpdateUsers', () async {
    const user = PartialUpdateUserRequest(
      id: 'test-user-id',
      set: {'color': 'yellow'},
    );

    const path = '/users';

    final updatedUser = {user.id: User(id: user.id, extraData: user.set!)};

    when(() => client.patch(path, data: {
          'users': [user],
        })).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'users':
              updatedUser.map((key, value) => MapEntry(key, value.toJson()))
        },
      ),
    );

    final res = await userApi.partialUpdateUsers([user]);

    expect(res, isNotNull);
    expect(res.users.length, updatedUser.length);

    verify(() => client.patch(path, data: {
          'users': [user]
        })).called(1);
    verifyNoMoreInteractions(client);
  });

  test('blockUser', () async {
    const targetUserId = 'test-target-user-id';

    const path = '/users/block';

    when(() => client.post(path, data: {
          'blocked_user_id': targetUserId,
        })).thenAnswer(
      (_) async => successResponse(
        path,
        data: {
          'blocked_by_user_id': 'deven',
          'blocked_user_id': 'jaap',
          'created_at': '2024-10-01 12:45:23.456',
        },
      ),
    );

    final res = await userApi.blockUser(targetUserId);

    expect(res, isNotNull);

    verify(() => client.post(path, data: {
          'blocked_user_id': targetUserId,
        })).called(1);
    verifyNoMoreInteractions(client);
  });

  test('unblockUser', () async {
    const targetUserId = 'test-target-user-id';

    const path = '/users/unblock';

    when(() => client.post(path, data: {
          'blocked_user_id': targetUserId,
        })).thenAnswer(
      (_) async => successResponse(
        path,
        data: <String, dynamic>{},
      ),
    );

    final res = await userApi.unblockUser(targetUserId);

    expect(res, isNotNull);

    verify(() => client.post(path, data: {
          'blocked_user_id': targetUserId,
        })).called(1);
    verifyNoMoreInteractions(client);
  });

  test('queryBlockedUsers', () async {
    const path = '/users/block';

    when(() => client.get(path)).thenAnswer(
      (_) async => successResponse(path, data: <String, dynamic>{}),
    );

    final res = await userApi.queryBlockedUsers();

    expect(res, isNotNull);

    verify(() => client.get(path)).called(1);
    verifyNoMoreInteractions(client);
  });

  test('getUnreadCount', () async {
    const path = '/unread';

    when(() => client.get(path)).thenAnswer(
      (_) async => successResponse(path, data: {
        'duration': '5.23ms',
        'total_unread_count': 42,
        'total_unread_threads_count': 8,
        'total_unread_count_by_team': {'team-1': 15, 'team-2': 27},
        'channels': [
          {
            'channel_id': 'messaging:test-channel-1',
            'unread_count': 5,
            'last_read': '2024-01-15T10:30:00.000Z',
          },
          {
            'channel_id': 'messaging:test-channel-2',
            'unread_count': 10,
            'last_read': '2024-01-15T09:15:00.000Z',
          },
        ],
        'channel_type': [
          {
            'channel_type': 'messaging',
            'channel_count': 3,
            'unread_count': 25,
          },
          {
            'channel_type': 'livestream',
            'channel_count': 1,
            'unread_count': 17,
          },
        ],
        'threads': [
          {
            'unread_count': 3,
            'last_read': '2024-01-15T10:30:00.000Z',
            'last_read_message_id': 'message-1',
            'parent_message_id': 'parent-message-1',
          },
          {
            'unread_count': 5,
            'last_read': '2024-01-15T09:45:00.000Z',
            'last_read_message_id': 'message-2',
            'parent_message_id': 'parent-message-2',
          },
        ],
      }),
    );

    final res = await userApi.getUnreadCount();

    expect(res, isNotNull);
    expect(res.totalUnreadCount, 42);
    expect(res.totalUnreadThreadsCount, 8);
    expect(res.totalUnreadCountByTeam, {'team-1': 15, 'team-2': 27});
    expect(res.channels.length, 2);
    expect(res.channelType.length, 2);
    expect(res.threads.length, 2);

    verify(() => client.get(path)).called(1);
    verifyNoMoreInteractions(client);
  });
}
