import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/open_api/api.dart' as api;
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('StreamChatClient.getUnreadCount returns the unread counts', () async {
    final defaultApi = MockDefaultApi();
    when(defaultApi.unreadCounts).thenAnswer((_) async => Result.success(_unreadCountsResponse()));
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
            api.UnreadCountsChannel(channelId: 'messaging:one', lastRead: DateTime.utc(2024), unreadCount: 10),
            api.UnreadCountsChannel(channelId: 'messaging:two', lastRead: DateTime.utc(2024), unreadCount: 15),
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
    final client = _clientWithOwnUser(defaultApi);

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
    final client = _clientWithOwnUser(defaultApi);

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

// A client whose current user starts with 4 unread messages in 3 channels and 2 unread threads.
StreamChatClient _clientWithOwnUser(api.DefaultApi defaultApi) {
  final client = _client(defaultApi);
  client.state
    ..currentUser = OwnUser(id: 'user-id', totalUnreadCount: 4, unreadChannels: 3, unreadThreads: 2)
    ..subscribeToEvents();
  return client;
}

api.WrappedUnreadCountsResponse _unreadCountsResponse({
  int totalUnreadCount = 42,
  List<api.UnreadCountsChannel>? channels,
  List<api.UnreadCountsThread>? threads,
}) {
  return api.WrappedUnreadCountsResponse(
    duration: '4.21ms',
    totalUnreadCount: totalUnreadCount,
    totalUnreadThreadsCount: 8,
    totalUnreadCountByTeam: const {'team-1': 15, 'team-2': 27},
    channels:
        channels ??
        [
          api.UnreadCountsChannel(
            channelId: 'messaging:general',
            lastRead: DateTime.utc(2024, 1, 15, 10, 30),
            unreadCount: 5,
          ),
        ],
    channelType: const [
      api.UnreadCountsChannelType(channelCount: 3, channelType: 'messaging', unreadCount: 25),
    ],
    threads:
        threads ??
        [
          api.UnreadCountsThread(
            lastRead: DateTime.utc(2024, 1, 15, 9, 45),
            lastReadMessageId: 'last-read-message-id',
            parentMessageId: 'parent-message-id',
            unreadCount: 7,
          ),
        ],
  );
}
