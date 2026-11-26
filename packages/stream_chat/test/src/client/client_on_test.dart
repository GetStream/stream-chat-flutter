import 'dart:async';

import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../utils.dart';
import '../ws/fake_chat_server.dart';

void main() {
  test('StreamChatClient.on with a type argument delivers only events of that class', () async {
    final client = _client();
    final messageNew = _messageNew();

    final delivered = await _deliveredOn(client, client.on<MessageNewEvent>(), [
      _typingStart(),
      messageNew,
    ]);

    expect(delivered, [messageNew]);
  });

  test('StreamChatClient.on with a marker type argument delivers events of every class carrying it', () async {
    final client = _client();
    final messageNew = _messageNew();
    final messageUpdated = MessageUpdatedEvent(
      cid: _cid,
      message: Message(id: 'message-id'),
    );

    final delivered = await _deliveredOn(client, client.on<HasMessage>(), [
      messageNew,
      _typingStart(),
      messageUpdated,
    ]);

    expect(delivered, [messageNew, messageUpdated]);
  });

  test('StreamChatClient.on with an event type delivers every event of that type, whatever its class', () async {
    final client = _client();
    final messageNew = _messageNew();
    final unknownMessageNew = UnknownEvent(type: EventType.messageNew);

    final delivered = await _deliveredOn(client, client.on(EventType.messageNew), [
      messageNew,
      _typingStart(),
      unknownMessageNew,
    ]);

    expect(delivered, [messageNew, unknownMessageNew]);
  });

  test('StreamChatClient.on with a type argument and an event type delivers only events matching both', () async {
    final client = _client();
    final unknownMessageNew = UnknownEvent(type: EventType.messageNew);

    final delivered = await _deliveredOn(client, client.on<UnknownEvent>(EventType.messageNew), [
      _messageNew(),
      UnknownEvent(type: 'party.started'),
      unknownMessageNew,
    ]);

    expect(delivered, [unknownMessageNew]);
  });

  test('StreamChatClient reports a new message sharing a location as a LocationSharedEvent', () async {
    final client = _client();
    final shared = client.on<LocationSharedEvent>().first;
    final message = Message(
      id: 'message-id',
      sharedLocation: Location(latitude: 40.7128, longitude: -74.0060),
    );

    client.handleEvent(MessageNewEvent(cid: _cid, message: message, watcherCount: 1));

    expect((await shared).message, message);
  });

  test('StreamChatClient delivers a notification.reminder_due it receives as a NotificationReminderDueEvent', () async {
    final server = FakeChatServer(user: OwnUser.fromUser(_user));
    final client = await _connectedClient(server);
    final due = client.on<NotificationReminderDueEvent>().first;

    server.send({
      'type': EventType.notificationReminderDue,
      'cid': _cid,
      'message_id': 'message-id',
      'user_id': _user.id,
      'created_at': '2026-11-25T12:00:00Z',
      'custom': <String, Object?>{},
      'reminder': {
        'channel_cid': _cid,
        'message_id': 'message-id',
        'user_id': _user.id,
        'created_at': '2026-11-25T11:00:00Z',
        'updated_at': '2026-11-25T11:00:00Z',
      },
    });

    expect((await due).messageId, 'message-id');
  });
}

const _cid = 'messaging:general';

final _user = User(id: 'test-user-id');

MessageNewEvent _messageNew() => MessageNewEvent(
  cid: _cid,
  message: Message(id: 'message-id'),
  watcherCount: 1,
);

TypingStartEvent _typingStart() => TypingStartEvent(
  cid: _cid,
  user: User(id: 'other-user'),
);

// A client with no user connected, connecting through [server] when asked to.
StreamChatClient _client({FakeChatServer? server}) {
  final client = StreamChatClient(
    'test-api-key',
    defaultApi: FakeDefaultApi(),
    chatApi: FakeChatApi(),
    wsProvider: (server ?? FakeChatServer()).connect,
  );
  addTearDown(client.dispose);
  return client;
}

// A client connected as [_user] through [server].
Future<StreamChatClient> _connectedClient(FakeChatServer server) async {
  final client = _client(server: server);
  await client.connectUser(_user, testUserToken(_user.id).rawValue);
  return client;
}

// The events [stream] delivers while [events] are handed to [client].
Future<List<Object?>> _deliveredOn(StreamChatClient client, Stream<Object?> stream, List<ChatEvent> events) async {
  final delivered = <Object?>[];
  final subscription = stream.listen(delivered.add);
  addTearDown(subscription.cancel);

  events.forEach(client.handleEvent);
  await pumpEventQueue();

  return delivered;
}
