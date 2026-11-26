import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  test('ClientState updates currentUser from an event carrying the current user', () async {
    final client = _client(OwnUser(id: 'user-id', name: 'Alice'));
    final mutedUser = User(id: 'muted-user-id');
    final me = OwnUser(
      id: 'user-id',
      mutes: [Mute(user: mutedUser, target: mutedUser, createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026))],
    );

    client.handleEvent(NotificationMutesUpdatedEvent(me: me));
    await pumpEventQueue();

    expect(client.state.currentUser!.mutes.map((it) => it.target.id), ['muted-user-id']);
  });

  test('ClientState takes the total unread count from an event carrying it', () async {
    final event = NotificationMarkReadEvent(cid: 'messaging:general', totalUnreadCount: 7, unreadChannels: 1);

    final client = _client(OwnUser(id: 'user-id', totalUnreadCount: 1))..handleEvent(event);
    await pumpEventQueue();

    expect(client.state.currentUser!.totalUnreadCount, 7);
  });

  test('ClientState takes the unread channel count from an event carrying it', () async {
    final event = NotificationMarkReadEvent(cid: 'messaging:general', totalUnreadCount: 1, unreadChannels: 3);

    final client = _client(OwnUser(id: 'user-id', unreadChannels: 1))..handleEvent(event);
    await pumpEventQueue();

    expect(client.state.currentUser!.unreadChannels, 3);
  });

  test('ClientState takes the unread thread count from an event carrying it', () async {
    final event = NotificationMarkReadEvent(
      cid: 'messaging:general',
      totalUnreadCount: 1,
      unreadChannels: 1,
      unreadThreads: 4,
    );

    final client = _client(OwnUser(id: 'user-id', unreadThreads: 1))..handleEvent(event);
    await pumpEventQueue();

    expect(client.state.currentUser!.unreadThreads, 4);
  });
}

// A client whose state follows its events for [currentUser], with no
// connection.
StreamChatClient _client(OwnUser currentUser) {
  final client = StreamChatClient('test-api-key', defaultApi: MockDefaultApi());
  addTearDown(client.dispose);
  client.state
    ..currentUser = currentUser
    ..subscribeToEvents();
  return client;
}
