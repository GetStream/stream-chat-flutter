import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import 'users_fixtures.dart';

void main() {
  setUpAll(() => registerFallbackValue(const api.UpdateUsersPartialRequest(users: [])));

  test('StreamChatClient.updateUserPartial sends the set and unset fields and returns the updated users', () async {
    const request = api.UpdateUsersPartialRequest(
      users: [
        api.UpdateUserPartialRequest(id: 'user-id', set: {'favorite_color': 'green'}, unset: ['nickname']),
      ],
    );
    final defaultApi = _defaultApiAnswering(Result.success(updateUsersResponse()));
    final client = _client(defaultApi);

    final res = await client.updateUserPartial(
      'user-id',
      set: const {'favorite_color': 'green'},
      unset: const ['nickname'],
    );

    expect(
      res.getOrNull(),
      UpdateUsersResponse(duration: '4.21ms', users: {'user-id': updatedUser()}),
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
    final defaultApi = _defaultApiAnswering(Result.success(updateUsersResponse()));
    final client = _client(defaultApi);

    final res = await client.updateUsersPartial(const [
      UpdateUserPartialRequest(id: 'first', set: {'a': 1}),
      UpdateUserPartialRequest(id: 'second', unset: ['b']),
    ]);

    expect(res.getOrNull(), UpdateUsersResponse(duration: '4.21ms', users: {'user-id': updatedUser()}));
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
