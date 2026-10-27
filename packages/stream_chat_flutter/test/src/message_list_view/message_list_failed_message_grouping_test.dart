import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  final maya = User(id: 'maya', name: 'Maya Ross');
  final failed = MessageState.sendingFailed(skipPush: false, skipEnrichUrl: false);

  Message message(String id, {MessageState state = MessageState.sent}) => Message(
    id: id,
    text: id,
    createdAt: DateTime(2026, 8, 26, 14),
    user: maya,
    state: state,
  );

  Finder footerOf(String id) => find.byWidgetPredicate(
    (widget) => widget is StreamMessageFooter && widget.props.message.id == id,
  );

  testWidgets('StreamMessageListView shows the footer of a sent message followed by a failed one', (tester) async {
    final chat = _FakeChat();
    await chat.pumpMessages(tester, [
      message('sent'),
      message('failed', state: failed),
    ]);

    expect(footerOf('sent'), findsOneWidget);
    expect(footerOf('failed'), findsOneWidget);
  });

  testWidgets('StreamMessageListView groups consecutive failed messages', (tester) async {
    final chat = _FakeChat();
    await chat.pumpMessages(tester, [
      message('first failed', state: failed),
      message('second failed', state: failed),
    ]);

    expect(footerOf('first failed'), findsNothing);
    expect(footerOf('second failed'), findsOneWidget);
  });

  testWidgets('StreamMessageListView groups consecutive sent messages', (tester) async {
    final chat = _FakeChat();
    await chat.pumpMessages(tester, [
      message('first sent'),
      message('second sent'),
    ]);

    expect(footerOf('first sent'), findsNothing);
    expect(footerOf('second sent'), findsOneWidget);
  });

  testWidgets('StreamMessageListView groups a failed message again once it is sent', (tester) async {
    final chat = _FakeChat();
    await chat.pumpMessages(tester, [
      message('sent'),
      message('retried', state: failed),
    ]);
    await chat.emitMessages(tester, [
      message('sent'),
      message('retried'),
    ]);

    expect(footerOf('sent'), findsNothing);
    expect(footerOf('retried'), findsOneWidget);
  });

  testWidgets('StreamMessageListView spaces a failed message apart from the sent one before it', (tester) async {
    final spacings = <List<SpacingType>>[];
    final chat = _FakeChat();
    await chat.pumpMessages(
      tester,
      [
        message('sent'),
        message('failed', state: failed),
      ],
      list: StreamMessageListView(
        builders: StreamMessageListViewBuilders(
          spacing: (context, spacingTypes) {
            spacings.add(spacingTypes);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(spacings, everyElement(contains(SpacingType.otherUser)));
  });
}

// A channel whose messages a test controls, for pumping a message list.
class _FakeChat {
  _FakeChat() {
    final clientState = MockClientState();
    final ownUser = OwnUser(id: 'maya', name: 'Maya Ross');
    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(ownUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));

    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelState);

    when(() => channelState.threadsStream).thenAnswer((_) => const Stream.empty());
    when(() => channelState.isUpToDate).thenReturn(true);
    when(() => channelState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
    when(() => channelState.unreadCount).thenReturn(0);
    when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));
    when(() => channelState.readStream).thenAnswer((_) => const Stream.empty());
    when(() => channelState.read).thenReturn([]);
    when(() => channelState.membersStream).thenAnswer((_) => const Stream.empty());
    when(() => channelState.members).thenReturn([]);
    when(() => channelState.currentUserRead).thenReturn(null);
    when(() => channelState.currentUserReadStream).thenAnswer((_) => const Stream.empty());
    when(() => channelState.messagesStream).thenAnswer((_) => _messages.stream);
  }

  final client = MockClient();
  final channel = MockChannel();
  final channelState = MockChannelState();
  final _messages = StreamController<List<Message>>.broadcast();

  // Pumps [list] below a channel showing [messages].
  Future<void> pumpMessages(
    WidgetTester tester,
    List<Message> messages, {
    Widget list = const StreamMessageListView(),
  }) async {
    addTearDown(_messages.close);
    when(() => channelState.messages).thenReturn(messages);
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
          child: StreamChannel(channel: channel, child: list),
        ),
      ),
    );
    _messages.add(messages);
    await tester.pumpAndSettle();
  }

  // Replaces the channel's messages with [messages] and lets the list rebuild.
  Future<void> emitMessages(WidgetTester tester, List<Message> messages) async {
    when(() => channelState.messages).thenReturn(messages);
    _messages.add(messages);
    await tester.pumpAndSettle();
  }
}
