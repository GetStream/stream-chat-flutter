import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  const currentUserId = 'me';

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
      createdAt: DateTime(2024, 1, 1),
    );

    await pumpWithMessages(tester, [message]);

    expect(find.text('hello world'), findsOneWidget);
  });

  testWidgets('hides shadowed message from another user', (tester) async {
    final visible = Message(
      text: 'visible',
      user: User(id: 'other'),
      createdAt: DateTime(2024, 1, 1),
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
        createdAt: DateTime(2024, 1, 1),
      );

      await pumpWithMessages(tester, [mine]);

      expect(find.text('my shadowed'), findsOneWidget);
    },
  );

  testWidgets(
    'hides moderation V2 shadowed message regardless of sender',
    (tester) async {
      final visible = Message(
        text: 'visible',
        user: User(id: currentUserId),
        createdAt: DateTime(2024, 1, 1),
      );
      final v2Shadowed = Message(
        text: 'v2 shadowed',
        user: User(id: currentUserId),
        createdAt: DateTime(2024, 1, 2),
        moderation: const Moderation(
          action: ModerationAction.shadow,
          originalText: 'v2 shadowed',
        ),
      );

      await pumpWithMessages(tester, [visible, v2Shadowed]);

      expect(find.text('visible'), findsOneWidget);
      expect(find.text('v2 shadowed'), findsNothing);
    },
  );

  testWidgets('hides deleted, error, and ephemeral messages', (tester) async {
    final visible = Message(
      text: 'visible',
      user: User(id: 'other'),
      createdAt: DateTime(2024, 1, 1),
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
        createdAt: DateTime(2024, 1, 1),
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
}
