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
    const sort = [SortOption('test-field')];
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
}
