import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  const currentUserId = 'me';

  // The default English translation; matches `emptyMessagesText`.
  const emptyText = 'There are no messages currently';

  late MockClient client;
  late MockClientState clientState;
  late MockChannel channel;
  late MockChannelState channelState;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    channel = MockChannel();
    channelState = MockChannelState();

    final currentUser = OwnUser(id: currentUserId, name: 'Me');

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(currentUser);
    when(() => clientState.currentUserStream)
        .thenAnswer((_) => Stream.value(currentUser));
    when(() => channel.state).thenReturn(channelState);
    when(() => channel.client).thenReturn(client);
    when(() => channelState.draft).thenReturn(null);
    when(() => channelState.draftStream).thenAnswer((_) => Stream.value(null));
    when(() => channelState.channelState).thenReturn(const ChannelState());
  });

  Future<void> pumpWithMessages(
    WidgetTester tester,
    List<Message> messages,
  ) async {
    when(() => channelState.messages).thenReturn(messages);
    when(() => channelState.messagesStream)
        .thenAnswer((_) => Stream.value(messages));

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          child: Scaffold(
            body: ChannelLastMessageText(channel: channel),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the latest message text as preview', (tester) async {
    final message = Message(
      text: 'hello world',
      user: User(id: 'other'),
      createdAt: DateTime(2024),
    );

    await pumpWithMessages(tester, [message]);

    expect(find.text('hello world'), findsOneWidget);
  });

  testWidgets('hides shadowed message from another user', (tester) async {
    final visible = Message(
      text: 'visible',
      user: User(id: 'other'),
      createdAt: DateTime(2024),
    );
    final shadowed = Message(
      text: 'shadowed',
      shadowed: true,
      user: User(id: 'other'),
      createdAt: DateTime(2024, 1, 2),
    );

    await pumpWithMessages(tester, [visible, shadowed]);

    expect(find.text('visible'), findsOneWidget);
    expect(find.text('shadowed'), findsNothing);
  });

  testWidgets(
    'shows current user own shadowed message',
    (tester) async {
      final mine = Message(
        text: 'my shadowed',
        shadowed: true,
        user: User(id: currentUserId),
        createdAt: DateTime(2024),
      );

      await pumpWithMessages(tester, [mine]);

      expect(find.text('my shadowed'), findsOneWidget);
    },
  );

  testWidgets('hides deleted, error, and ephemeral messages', (tester) async {
    final visible = Message(
      text: 'visible',
      user: User(id: 'other'),
      createdAt: DateTime(2024),
    );
    final deleted = Message(
      text: 'deleted',
      type: MessageType.deleted,
      user: User(id: 'other'),
      createdAt: DateTime(2024, 1, 2),
    );
    final errored = Message(
      text: 'errored',
      type: MessageType.error,
      user: User(id: 'other'),
      createdAt: DateTime(2024, 1, 3),
    );
    final ephemeral = Message(
      text: 'ephemeral',
      type: MessageType.ephemeral,
      user: User(id: 'other'),
      createdAt: DateTime(2024, 1, 4),
    );

    await pumpWithMessages(tester, [visible, deleted, errored, ephemeral]);

    expect(find.text('visible'), findsOneWidget);
    expect(find.text('deleted'), findsNothing);
    expect(find.text('errored'), findsNothing);
    expect(find.text('ephemeral'), findsNothing);
  });

  testWidgets(
    'custom lastMessagePredicate fully replaces the default',
    (tester) async {
      final shadowedByOther = Message(
        text: 'shadowed by other',
        shadowed: true,
        user: User(id: 'other'),
        createdAt: DateTime(2024),
      );

      when(() => channelState.messages).thenReturn([shadowedByOther]);
      when(() => channelState.messagesStream)
          .thenAnswer((_) => Stream.value([shadowedByOther]));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelLastMessageText(
                channel: channel,
                lastMessagePredicate: (_) => true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('shadowed by other'), findsOneWidget);
    },
  );

  testWidgets(
    'preserves the last-known message when state is not up-to-date and '
    'emits empty',
    (tester) async {
      final other = User(id: 'other');
      final msg1 = Message(id: 'm1', text: 'hello', user: other);

      final controller = StreamController<List<Message>>.broadcast();
      addTearDown(controller.close);

      var isUpToDate = true;
      when(() => channelState.isUpToDate).thenAnswer((_) => isUpToDate);
      when(() => channelState.messages).thenReturn([msg1]);
      when(() => channelState.messagesStream)
          .thenAnswer((_) => controller.stream);

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelLastMessageText(channel: channel),
            ),
          ),
        ),
      );
      controller.add([msg1]);
      await tester.pumpAndSettle();

      expect(find.text('hello'), findsOneWidget);
      expect(find.text(emptyText), findsNothing);

      // While loading a historical window, isUpToDate flips false and the
      // intermediate state emits an empty messages list.
      isUpToDate = false;
      controller.add([]);
      await tester.pumpAndSettle();

      expect(find.text('hello'), findsOneWidget);
      expect(find.text(emptyText), findsNothing);

      // The loaded window arrives; isUpToDate restored.
      final msg2 = Message(id: 'm2', text: 'world', user: other);
      isUpToDate = true;
      controller.add([msg1, msg2]);
      await tester.pumpAndSettle();

      expect(find.text('world'), findsOneWidget);
      expect(find.text(emptyText), findsNothing);
    },
  );

  testWidgets(
    "rebinding the widget to a different channel shows that channel's "
    "state, not the previous one's",
    (tester) async {
      // List reordering reuses the underlying State across channels (no key
      // on the list item). Channel B is empty; channel A had a message —
      // the cell must render B's empty state, not A's last message.
      final other = User(id: 'other');
      final msgA = Message(id: 'ma', text: 'channel-a-message', user: other);

      when(() => channelState.messages).thenReturn([msgA]);
      when(() => channelState.messagesStream)
          .thenAnswer((_) => Stream.value([msgA]));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelLastMessageText(channel: channel),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('channel-a-message'), findsOneWidget);

      final channelB = MockChannel(id: 'b', type: 'messaging');
      final channelStateB = MockChannelState();
      when(() => channelB.client).thenReturn(client);
      when(() => channelB.state).thenReturn(channelStateB);
      when(() => channelStateB.draft).thenReturn(null);
      when(() => channelStateB.draftStream)
          .thenAnswer((_) => Stream.value(null));
      when(() => channelStateB.channelState).thenReturn(const ChannelState());
      when(() => channelStateB.messages).thenReturn([]);
      when(() => channelStateB.messagesStream)
          .thenAnswer((_) => Stream.value(<Message>[]));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelLastMessageText(channel: channelB),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('channel-a-message'), findsNothing);
      expect(find.text(emptyText), findsOneWidget);
    },
  );

  testWidgets(
    'shows the empty-state when the channel is truncated while up-to-date',
    (tester) async {
      // A channel.truncated event clears messages but leaves isUpToDate true.
      // The preview must reflect the now-empty channel.
      final other = User(id: 'other');
      final msg1 = Message(id: 'm1', text: 'hello', user: other);

      final controller = StreamController<List<Message>>.broadcast();
      addTearDown(controller.close);

      when(() => channelState.messages).thenReturn([msg1]);
      when(() => channelState.messagesStream)
          .thenAnswer((_) => controller.stream);

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelLastMessageText(channel: channel),
            ),
          ),
        ),
      );
      controller.add([msg1]);
      await tester.pumpAndSettle();

      expect(find.text('hello'), findsOneWidget);

      controller.add([]);
      await tester.pumpAndSettle();

      expect(find.text('hello'), findsNothing);
      expect(find.text(emptyText), findsOneWidget);
    },
  );
}
