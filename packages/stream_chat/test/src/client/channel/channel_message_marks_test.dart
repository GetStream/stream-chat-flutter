import 'dart:async';

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
const _viewed = MessageMarkType('acme.viewed');

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

  test('a mark on a pinned message outside the loaded page reaches it', () async {
    final pinned = _voiceNote(
      id: 'older-voice-note',
      author: _currentUser,
    ).copyWith(pinned: true);
    final (client, channel) = _channel(
      author: _currentUser,
      pinnedMessages: [pinned],
    );
    addTearDown(channel.dispose);

    final markAdded = _markAdded(
      channel,
      by: 'listener',
      messageId: 'older-voice-note',
    );
    client.addEvent(markAdded);
    await Future<void>.delayed(Duration.zero);

    final storedPinned = channel.state!.pinnedMessages.single;
    expect(_playedGroup(storedPinned).count, 1);
  });

  group('markMessage', () {
    setUpAll(() => registerFallbackValue(MessageMarkType.played));

    test("marks another user's message played once", () async {
      final (client, channel) = _channel(author: _otherUser);
      addTearDown(channel.dispose);
      when(() => client.sendMessageMark(any(), any())).thenAnswer((_) async => SendMessageMarkResponse());
      final message = channel.state!.messages.single;

      expect(await channel.markMessage(message, MessageMarkType.played), isNotNull);
      expect(await channel.markMessage(message, MessageMarkType.played), isNull);

      verify(() => client.sendMessageMark('voice-note', MessageMarkType.played)).called(1);
    });

    test('skips the message while the same mark is in flight', () async {
      final (client, channel) = _channel(author: _otherUser);
      addTearDown(channel.dispose);
      final response = Completer<SendMessageMarkResponse>();
      when(() => client.sendMessageMark(any(), any())).thenAnswer((_) => response.future);
      final message = channel.state!.messages.single;

      final first = channel.markMessage(message, MessageMarkType.played);
      expect(await channel.markMessage(message, MessageMarkType.played), isNull);
      response.complete(SendMessageMarkResponse());
      expect(await first, isNotNull);

      verify(() => client.sendMessageMark(any(), any())).called(1);
    });

    test('throws when the mark fails', () async {
      final (client, channel) = _channel(author: _otherUser);
      addTearDown(channel.dispose);
      when(
        () => client.sendMessageMark(any(), any()),
      ).thenAnswer((_) async => throw StreamChatNetworkError(ChatErrorCode.internalSystemError));
      final message = channel.state!.messages.single;

      await expectLater(channel.markMessage(message, MessageMarkType.played), throwsA(isA<StreamChatNetworkError>()));
    });

    test('tries again after a failed mark', () async {
      final (client, channel) = _channel(author: _otherUser);
      addTearDown(channel.dispose);
      when(
        () => client.sendMessageMark(any(), any()),
      ).thenAnswer((_) async => throw StreamChatNetworkError(ChatErrorCode.internalSystemError));
      final message = channel.state!.messages.single;
      await expectLater(channel.markMessage(message, MessageMarkType.played), throwsA(isA<StreamChatNetworkError>()));

      when(() => client.sendMessageMark(any(), any())).thenAnswer((_) async => SendMessageMarkResponse());

      expect(await channel.markMessage(message, MessageMarkType.played), isNotNull);
    });

    test('marks a message with another type after a played mark', () async {
      final (client, channel) = _channel(author: _otherUser);
      addTearDown(channel.dispose);
      when(() => client.sendMessageMark(any(), any())).thenAnswer((_) async => SendMessageMarkResponse());
      final message = channel.state!.messages.single;

      await channel.markMessage(message, MessageMarkType.played);

      expect(await channel.markMessage(message, _viewed), isNotNull);
      verify(() => client.sendMessageMark('voice-note', _viewed)).called(1);
    });

    test("skips the current user's own message", () async {
      final (client, channel) = _channel(author: _currentUser);
      addTearDown(channel.dispose);

      expect(await channel.markMessage(channel.state!.messages.single, MessageMarkType.played), isNull);

      verifyNever(() => client.sendMessageMark(any(), any()));
    });
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

// A channel holding one voice note by [author], plus any [pinnedMessages].
(MockStreamChatClient, Channel) _channel({
  required User author,
  Map<MessageMarkType, MarkGroup>? markGroups,
  List<Message>? pinnedMessages,
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
    channel: ChannelModel(
      id: 'test-channel-id',
      type: 'messaging',
      ownCapabilities: [ChannelCapability.sendMessageMark],
      config: ChannelConfig(markTypes: const [MessageMarkType.played, _viewed]),
    ),
    messages: [voiceNote],
    pinnedMessages: pinnedMessages,
  );

  return (client, Channel.fromState(client, channelState));
}

Message _voiceNote({
  String id = 'voice-note',
  required User author,
  String? parentId,
  String text = 'voice note',
  Map<MessageMarkType, MarkGroup>? markGroups,
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
