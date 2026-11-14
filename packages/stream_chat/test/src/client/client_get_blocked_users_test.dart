import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  test('StreamChatClient.getBlockedUsers returns the blocks', () async {
    final defaultApi = MockDefaultApi();
    when(defaultApi.getBlockedUsers).thenAnswer(
      (_) async => Result.success(
        api.GetBlockedUsersResponse(
          duration: '4.21ms',
          blocks: [
            api.BlockedUserResponse(
              user: fakeUserResponse('user-id'),
              blockedUser: fakeUserResponse('blocked-user-1'),
              userId: 'user-id',
              blockedUserId: 'blocked-user-1',
              createdAt: DateTime.utc(2026, 10, 1),
            ),
            api.BlockedUserResponse(
              user: fakeUserResponse('user-id'),
              blockedUser: fakeUserResponse('blocked-user-2'),
              userId: 'user-id',
              blockedUserId: 'blocked-user-2',
              createdAt: DateTime.utc(2026, 10, 2),
            ),
          ],
        ),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.getBlockedUsers();

    expect(
      res.getOrNull(),
      GetBlockedUsersResponse(
        duration: '4.21ms',
        blocks: [
          UserBlock(
            user: fakeUser('user-id'),
            blockedUser: fakeUser('blocked-user-1'),
            userId: 'user-id',
            blockedUserId: 'blocked-user-1',
            createdAt: DateTime.utc(2026, 10, 1),
          ),
          UserBlock(
            user: fakeUser('user-id'),
            blockedUser: fakeUser('blocked-user-2'),
            userId: 'user-id',
            blockedUserId: 'blocked-user-2',
            createdAt: DateTime.utc(2026, 10, 2),
          ),
        ],
      ),
    );
    verify(defaultApi.getBlockedUsers).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test("StreamChatClient.getBlockedUsers replaces the current user's blocked user ids", () async {
    final defaultApi = MockDefaultApi();
    when(defaultApi.getBlockedUsers).thenAnswer(
      (_) async => Result.success(
        api.GetBlockedUsersResponse(
          duration: '4.21ms',
          blocks: [_block('blocked-user-1'), _block('blocked-user-2')],
        ),
      ),
    );
    final client = _clientWithOwnUser(defaultApi, blockedUserIds: const ['stale-blocked-user']);

    await client.getBlockedUsers();

    expect(client.state.currentUser!.blockedUserIds, ['blocked-user-1', 'blocked-user-2']);
  });

  test('StreamChatClient.getBlockedUsers returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(defaultApi.getBlockedUsers).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.getBlockedUsers();

    expect(res.exceptionOrNull(), error);
  });

  test("StreamChatClient.getBlockedUsers leaves the current user's blocked user ids unchanged on failure", () async {
    final defaultApi = MockDefaultApi();
    when(defaultApi.getBlockedUsers).thenAnswer(
      (_) async => const Result.failure(StreamClientException(message: 'boom')),
    );
    final client = _clientWithOwnUser(defaultApi, blockedUserIds: const ['stale-blocked-user']);

    await client.getBlockedUsers();

    expect(client.state.currentUser!.blockedUserIds, ['stale-blocked-user']);
  });
}

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

api.BlockedUserResponse _block(String blockedUserId) => api.BlockedUserResponse(
  user: fakeUserResponse('user-id'),
  blockedUser: fakeUserResponse(blockedUserId),
  userId: 'user-id',
  blockedUserId: blockedUserId,
  createdAt: DateTime.utc(2026, 10, 1),
);
