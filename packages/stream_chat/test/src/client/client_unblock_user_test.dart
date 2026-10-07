import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('StreamChatClient.unblockUser sends the user id and returns the response', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.unblockUsers(unblockUsersRequest: _request)).thenAnswer(
      (_) async => const Result.success(api.UnblockUsersResponse(duration: '4.21ms')),
    );
    final client = _client(defaultApi);

    final res = await client.unblockUser(_blockedUserId);

    expect(res.getOrNull(), const UnblockUsersResponse(duration: '4.21ms'));
    verify(() => defaultApi.unblockUsers(unblockUsersRequest: _request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test("StreamChatClient.unblockUser removes the user from the current user's blocked user ids", () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.unblockUsers(unblockUsersRequest: _request)).thenAnswer(
      (_) async => const Result.success(api.UnblockUsersResponse(duration: '4.21ms')),
    );
    final client = _clientWithOwnUser(defaultApi, blockedUserIds: const [_blockedUserId, 'other-user']);

    await client.unblockUser(_blockedUserId);

    expect(client.state.currentUser!.blockedUserIds, ['other-user']);
  });

  test(
    "StreamChatClient.unblockUser leaves the current user's blocked user ids unchanged when the user was not blocked",
    () async {
      final defaultApi = MockDefaultApi();
      when(() => defaultApi.unblockUsers(unblockUsersRequest: _request)).thenAnswer(
        (_) async => const Result.success(api.UnblockUsersResponse(duration: '4.21ms')),
      );
      final client = _clientWithOwnUser(defaultApi, blockedUserIds: const ['other-user']);

      await client.unblockUser(_blockedUserId);

      expect(client.state.currentUser!.blockedUserIds, ['other-user']);
    },
  );

  test('StreamChatClient.unblockUser returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.unblockUsers(unblockUsersRequest: _request)).thenAnswer(
      (_) async => const Result.failure(error),
    );
    final client = _client(defaultApi);

    final res = await client.unblockUser(_blockedUserId);

    expect(res.exceptionOrNull(), error);
  });

  test("StreamChatClient.unblockUser leaves the current user's blocked user ids unchanged on failure", () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.unblockUsers(unblockUsersRequest: _request)).thenAnswer(
      (_) async => const Result.failure(StreamClientException(message: 'boom')),
    );
    final client = _clientWithOwnUser(defaultApi, blockedUserIds: const [_blockedUserId, 'other-user']);

    await client.unblockUser(_blockedUserId);

    expect(client.state.currentUser!.blockedUserIds, [_blockedUserId, 'other-user']);
  });
}

const _blockedUserId = 'blocked-user-id';
const _request = api.UnblockUsersRequest(blockedUserId: _blockedUserId);

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}

StreamChatClient _clientWithOwnUser(api.DefaultApi defaultApi, {required List<String> blockedUserIds}) {
  final client = _client(defaultApi);
  client.state.currentUser = OwnUser(id: 'user-id', blockedUserIds: blockedUserIds);
  return client;
}
