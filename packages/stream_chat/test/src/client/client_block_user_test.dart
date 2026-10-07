import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('StreamChatClient.blockUser sends the user id and returns the block', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.blockUsers(blockUsersRequest: _request)).thenAnswer(
      (_) async => Result.success(_blockUsersResponse()),
    );
    final client = _client(defaultApi);

    final res = await client.blockUser(_blockedUserId);

    expect(
      res.getOrNull(),
      BlockUserResponse(
        duration: '4.21ms',
        blockedByUserId: 'user-id',
        blockedUserId: _blockedUserId,
        createdAt: DateTime.utc(2026, 10, 7, 9, 30),
      ),
    );
    verify(() => defaultApi.blockUsers(blockUsersRequest: _request)).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test("StreamChatClient.blockUser adds the blocked user to the current user's blocked user ids", () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.blockUsers(blockUsersRequest: _request)).thenAnswer(
      (_) async => Result.success(_blockUsersResponse()),
    );
    final client = _clientWithOwnUser(defaultApi, blockedUserIds: const ['other-user']);

    await client.blockUser(_blockedUserId);

    expect(client.state.currentUser!.blockedUserIds, ['other-user', _blockedUserId]);
  });

  test('StreamChatClient.blockUser does not add an already blocked user again', () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.blockUsers(blockUsersRequest: _request)).thenAnswer(
      (_) async => Result.success(_blockUsersResponse()),
    );
    final client = _clientWithOwnUser(defaultApi, blockedUserIds: const [_blockedUserId]);

    await client.blockUser(_blockedUserId);

    expect(client.state.currentUser!.blockedUserIds, [_blockedUserId]);
  });

  test('StreamChatClient.blockUser returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.blockUsers(blockUsersRequest: _request)).thenAnswer(
      (_) async => const Result.failure(error),
    );
    final client = _client(defaultApi);

    final res = await client.blockUser(_blockedUserId);

    expect(res.exceptionOrNull(), error);
  });

  test("StreamChatClient.blockUser leaves the current user's blocked user ids unchanged on failure", () async {
    final defaultApi = MockDefaultApi();
    when(() => defaultApi.blockUsers(blockUsersRequest: _request)).thenAnswer(
      (_) async => const Result.failure(StreamClientException(message: 'boom')),
    );
    final client = _clientWithOwnUser(defaultApi, blockedUserIds: const ['other-user']);

    await client.blockUser(_blockedUserId);

    expect(client.state.currentUser!.blockedUserIds, ['other-user']);
  });
}

const _blockedUserId = 'blocked-user-id';
const _request = api.BlockUsersRequest(blockedUserId: _blockedUserId);

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

api.BlockUsersResponse _blockUsersResponse() => api.BlockUsersResponse(
  duration: '4.21ms',
  blockedByUserId: 'user-id',
  blockedUserId: _blockedUserId,
  createdAt: DateTime.utc(2026, 10, 7, 9, 30),
);
