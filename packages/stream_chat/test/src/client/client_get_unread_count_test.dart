import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('StreamChatClient.getUnreadCount returns the unread counts', () async {
    final defaultApi = MockDefaultApi();
    when(defaultApi.unreadCounts).thenAnswer(
      (_) async => Result.success(
        api.WrappedUnreadCountsResponse(
          duration: '4.21ms',
          totalUnreadCount: 42,
          totalUnreadThreadsCount: 8,
          totalUnreadCountByTeam: const {'team-1': 15, 'team-2': 27},
          channels: [
            api.UnreadCountsChannel(
              channelId: 'messaging:general',
              hasUnread: true,
              lastRead: DateTime.utc(2024, 1, 15, 10, 30),
              unreadCount: 5,
            ),
          ],
          channelType: const [
            api.UnreadCountsChannelType(channelCount: 3, channelType: 'messaging', unreadCount: 25),
          ],
          threads: [
            api.UnreadCountsThread(
              lastRead: DateTime.utc(2024, 1, 15, 9, 45),
              lastReadMessageId: 'last-read-message-id',
              parentMessageId: 'parent-message-id',
              unreadCount: 7,
            ),
          ],
        ),
      ),
    );
    final client = _client(defaultApi);

    final res = await client.getUnreadCount();

    expect(
      res.getOrNull(),
      GetUnreadCountResponse(
        duration: '4.21ms',
        totalUnreadCount: 42,
        totalUnreadThreadsCount: 8,
        totalUnreadCountByTeam: const {'team-1': 15, 'team-2': 27},
        channels: [
          UnreadCountsChannel(
            channelId: 'messaging:general',
            unreadCount: 5,
            lastRead: DateTime.utc(2024, 1, 15, 10, 30),
          ),
        ],
        channelType: const [
          UnreadCountsChannelType(channelType: 'messaging', channelCount: 3, unreadCount: 25),
        ],
        threads: [
          UnreadCountsThread(
            unreadCount: 7,
            lastRead: DateTime.utc(2024, 1, 15, 9, 45),
            lastReadMessageId: 'last-read-message-id',
            parentMessageId: 'parent-message-id',
          ),
        ],
      ),
    );
    verify(defaultApi.unreadCounts).called(1);
    verifyNoMoreInteractions(defaultApi);
  });

  test("StreamChatClient.getUnreadCount updates the current user's unread counts", () async {
    final defaultApi = MockDefaultApi();
    when(defaultApi.unreadCounts).thenAnswer(
      (_) async => Result.success(
        _unreadCountsResponse(
          totalUnreadCount: 25,
          channels: [
            api.UnreadCountsChannel(
              channelId: 'messaging:one',
              hasUnread: true,
              lastRead: DateTime.utc(2024),
              unreadCount: 10,
            ),
            api.UnreadCountsChannel(
              channelId: 'messaging:two',
              hasUnread: true,
              lastRead: DateTime.utc(2024),
              unreadCount: 15,
            ),
          ],
          threads: [
            api.UnreadCountsThread(
              lastRead: DateTime.utc(2024),
              lastReadMessageId: 'last-read-message-id',
              parentMessageId: 'parent-message-id',
              unreadCount: 3,
            ),
          ],
        ),
      ),
    );
    final client = _clientWithCurrentUser(
      defaultApi,
      OwnUser(id: 'user-id', totalUnreadCount: 4, unreadChannels: 3, unreadThreads: 2),
    );

    await client.getUnreadCount();
    await pumpEventQueue();

    final currentUser = client.state.currentUser!;
    expect(currentUser.totalUnreadCount, 25);
    expect(currentUser.unreadChannels, 2);
    expect(currentUser.unreadThreads, 1);
  });

  test('StreamChatClient.getUnreadCount returns the failure without throwing', () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(defaultApi.unreadCounts).thenAnswer((_) async => const Result.failure(error));
    final client = _client(defaultApi);

    final res = await client.getUnreadCount();

    expect(res.exceptionOrNull(), error);
  });

  test("StreamChatClient.getUnreadCount leaves the current user's unread counts unchanged on failure", () async {
    const error = StreamClientException(message: 'boom');
    final defaultApi = MockDefaultApi();
    when(defaultApi.unreadCounts).thenAnswer((_) async => const Result.failure(error));
    final client = _clientWithCurrentUser(
      defaultApi,
      OwnUser(id: 'user-id', totalUnreadCount: 4, unreadChannels: 3, unreadThreads: 2),
    );

    await client.getUnreadCount();
    await pumpEventQueue();

    final currentUser = client.state.currentUser!;
    expect(currentUser.totalUnreadCount, 4);
    expect(currentUser.unreadChannels, 3);
    expect(currentUser.unreadThreads, 2);
  });
}

StreamChatClient _client(api.DefaultApi defaultApi) {
  final client = StreamChatClient('test-api-key', defaultApi: defaultApi);
  addTearDown(client.dispose);
  return client;
}

StreamChatClient _clientWithCurrentUser(api.DefaultApi defaultApi, OwnUser currentUser) {
  final client = _client(defaultApi);
  client.state
    ..currentUser = currentUser
    ..subscribeToEvents();
  return client;
}

api.WrappedUnreadCountsResponse _unreadCountsResponse({
  required int totalUnreadCount,
  required List<api.UnreadCountsChannel> channels,
  required List<api.UnreadCountsThread> threads,
}) {
  return api.WrappedUnreadCountsResponse(
    duration: '4.21ms',
    totalUnreadCount: totalUnreadCount,
    totalUnreadThreadsCount: threads.length,
    channels: channels,
    channelType: const [],
    threads: threads,
  );
}
