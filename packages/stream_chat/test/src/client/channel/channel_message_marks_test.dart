import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

// Matches the default current user of [FakeClientState].
const _currentUserId = 'test-user-id';
final _currentUser = User(id: _currentUserId);
final _otherUser = User(id: 'other-user');
final _markedAt = DateTime.utc(2026, 11, 20, 10);

void main() {
  setUpAll(() => registerFallbackValue(FakeEvent()));

  test("a mark on the current user's message joins its mark groups", () async {
    final (client, channel) = _channel(author: _currentUser);
    addTearDown(channel.dispose);

    client.addEvent(_markAdded(channel, by: 'listener'));
    await Future<void>.delayed(Duration.zero);

    final marker = MessageMarker(userId: 'listener', createdAt: _markedAt);
    expect(channel.state!.messages.single.markGroups, {
      MessageMarkType.played: MarkGroup(count: 1, latestBy: [marker]),
    });
  });

  test('a mark received twice is counted once', () async {
    final (client, channel) = _channel(author: _currentUser);
    addTearDown(channel.dispose);

    client
      ..addEvent(_markAdded(channel, by: 'listener'))
      ..addEvent(_markAdded(channel, by: 'listener'));
    await Future<void>.delayed(Duration.zero);

    final group = _playedGroup(channel.state!.messages.single);
    expect(group.count, 1);
  });

  test('a newer mark is listed before the earlier ones', () async {
    final earlier = MessageMarker(
      userId: 'first-listener',
      createdAt: DateTime.utc(2026, 11, 19),
    );
    final (client, channel) = _channel(
      author: _currentUser,
      markGroups: {
        MessageMarkType.played: MarkGroup(count: 1, latestBy: [earlier]),
      },
    );
    addTearDown(channel.dispose);

    client.addEvent(_markAdded(channel, by: 'second-listener'));
    await Future<void>.delayed(Duration.zero);

    final group = _playedGroup(channel.state!.messages.single);
    final markers = group.latestBy.map((it) => it.userId);
    expect(markers, ['second-listener', 'first-listener']);
  });

  test("the current user's mark on another user's message joins its own marks", () async {
    final (client, channel) = _channel(author: _otherUser);
    addTearDown(channel.dispose);

    client.addEvent(_markAdded(channel, by: _currentUserId));
    await Future<void>.delayed(Duration.zero);

    final message = channel.state!.messages.single;
    final ownMark = OwnMark(type: MessageMarkType.played, createdAt: _markedAt);
    expect(message.ownMarks, [ownMark]);
    expect(message.markGroups, isNull);
  });

  test("the current user's mark received twice is kept once", () async {
    final (client, channel) = _channel(author: _otherUser);
    addTearDown(channel.dispose);

    client
      ..addEvent(_markAdded(channel, by: _currentUserId))
      ..addEvent(_markAdded(channel, by: _currentUserId));
    await Future<void>.delayed(Duration.zero);

    expect(channel.state!.messages.single.ownMarks, hasLength(1));
  });

  test("a mark by another user on another user's message is ignored", () async {
    final (client, channel) = _channel(author: _otherUser);
    addTearDown(channel.dispose);

    client.addEvent(_markAdded(channel, by: 'listener'));
    await Future<void>.delayed(Duration.zero);

    final message = channel.state!.messages.single;
    expect(message.markGroups, isNull);
    expect(message.ownMarks, isNull);
  });

  test('a mark on a message the channel does not hold is ignored', () async {
    final (client, channel) = _channel(author: _currentUser);
    addTearDown(channel.dispose);

    client.addEvent(
      _markAdded(channel, by: 'listener', messageId: 'unknown-message'),
    );
    await Future<void>.delayed(Duration.zero);

    expect(channel.state!.messages, hasLength(1));
    expect(channel.state!.messages.single.markGroups, isNull);
  });

  test('a mark group lists at most the latest 100 markers', () async {
    final (client, channel) = _channel(
      author: _currentUser,
      markGroups: {MessageMarkType.played: _fullGroup()},
    );
    addTearDown(channel.dispose);

    client.addEvent(_markAdded(channel, by: 'newest-listener'));
    await Future<void>.delayed(Duration.zero);

    final group = _playedGroup(channel.state!.messages.single);
    expect(group.latestBy, hasLength(100));
  });

  test('a mark past the 100 listed markers still counts', () async {
    final (client, channel) = _channel(
      author: _currentUser,
      markGroups: {MessageMarkType.played: _fullGroup()},
    );
    addTearDown(channel.dispose);

    client.addEvent(_markAdded(channel, by: 'newest-listener'));
    await Future<void>.delayed(Duration.zero);

    final group = _playedGroup(channel.state!.messages.single);
    expect(group.count, 151);
  });

  test('a mark on a thread reply reaches the reply', () async {
    final (client, channel) = _channel(author: _otherUser);
    addTearDown(channel.dispose);
    final reply = _voiceNote(
      id: 'voice-reply',
      author: _currentUser,
      parentId: 'voice-note',
    );
    channel.state!.updateThreadInfo('voice-note', [reply]);

    final markAdded = _markAdded(
      channel,
      by: 'listener',
      messageId: 'voice-reply',
      parentId: 'voice-note',
    );
    client.addEvent(markAdded);
    await Future<void>.delayed(Duration.zero);

    final storedReply = channel.state!.threads['voice-note']!.single;
    expect(_playedGroup(storedReply).count, 1);
  });

  test('an updated message keeps the marks the update leaves out', () async {
    final marker = MessageMarker(userId: 'listener', createdAt: _markedAt);
    final markGroups = {
      MessageMarkType.played: MarkGroup(count: 1, latestBy: [marker]),
    };
    final (client, channel) = _channel(
      author: _currentUser,
      markGroups: markGroups,
    );
    addTearDown(channel.dispose);

    final edited = _voiceNote(author: _currentUser, text: 'edited');
    client.addEvent(
      Event(
        cid: channel.cid,
        type: EventType.messageUpdated,
        message: edited,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final stored = channel.state!.messages.single;
    expect(stored.text, 'edited');
    expect(stored.markGroups, markGroups);
  });
}

// A channel holding one voice note by [author].
(MockStreamChatClient, Channel) _channel({
  required User author,
  Map<String, MarkGroup>? markGroups,
}) {
  final client = MockStreamChatClient();
  final logger = Logger.detached('test');
  final retryPolicy = RetryPolicy(
    shouldRetry: (_, __, ___) => false,
    delayFactor: Duration.zero,
  );
  final deliveryReporter = client.channelDeliveryReporter;

  when(() => client.detachedLogger(any())).thenReturn(logger);
  when(() => client.logger).thenReturn(logger);
  when(() => client.retryPolicy).thenReturn(retryPolicy);
  when(() => client.state).thenReturn(FakeClientState());
  when(
    () => deliveryReporter.submitForDelivery(any()),
  ).thenAnswer((_) async {});
  when(
    () => deliveryReporter.reconcileDelivery(any()),
  ).thenAnswer((_) async {});

  final voiceNote = _voiceNote(author: author, markGroups: markGroups);
  final channelState = ChannelState(
    channel: ChannelModel(id: 'test-channel-id', type: 'messaging'),
    messages: [voiceNote],
  );

  return (client, Channel.fromState(client, channelState));
}

Message _voiceNote({
  String id = 'voice-note',
  required User author,
  String? parentId,
  String text = 'voice note',
  Map<String, MarkGroup>? markGroups,
}) {
  return Message(
    id: id,
    text: text,
    user: author,
    parentId: parentId,
    createdAt: DateTime.utc(2026, 11, 20, 9),
    markGroups: markGroups,
  );
}

// A group of 150 markers that lists the latest 100 of them.
MarkGroup _fullGroup() {
  final markers = [
    for (var i = 0; i < 100; i++) MessageMarker(userId: 'listener-$i', createdAt: DateTime.utc(2026)),
  ];
  return MarkGroup(count: 150, latestBy: markers);
}

MarkGroup _playedGroup(Message message) {
  return message.markGroups![MessageMarkType.played]!;
}

Event _markAdded(
  Channel channel, {
  required String by,
  String messageId = 'voice-note',
  String? parentId,
}) {
  return Event(
    cid: channel.cid,
    type: EventType.messageMarkAdded,
    messageId: messageId,
    parentId: parentId,
    mark: MessageMark(
      type: MessageMarkType.played,
      messageId: messageId,
      userId: by,
      createdAt: _markedAt,
    ),
  );
}
