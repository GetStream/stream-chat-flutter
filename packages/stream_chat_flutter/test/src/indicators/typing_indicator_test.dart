import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late MockClient client;
  late MockClientState clientState;
  late MockChannel channel;
  late MockChannelState channelState;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    channel = MockChannel();
    channelState = MockChannelState();
    final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
    when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
    when(() => channel.state).thenReturn(channelState);
    when(() => channel.client).thenReturn(client);
    when(() => channel.isMuted).thenReturn(false);
    when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
    when(() => channel.extraDataStream).thenAnswer(
      (i) => Stream.value({
        'name': 'test',
      }),
    );
    when(() => channel.extraData).thenReturn({
      'name': 'test',
    });
    when(() => channelState.membersStream).thenAnswer(
      (i) => Stream.value([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]),
    );
    when(() => channelState.members).thenReturn([
      Member(
        userId: 'user-id',
        user: User(id: 'user-id'),
      ),
    ]);
    when(() => channelState.messages).thenReturn([
      Message(
        text: 'hello',
        user: User(id: 'other-user'),
      ),
    ]);
    when(() => channelState.messagesStream).thenAnswer(
      (i) => Stream.value([
        Message(
          text: 'hello',
          user: User(id: 'other-user'),
        ),
      ]),
    );
  });

  Widget buildTarget({Key? key}) {
    return MaterialApp(
      home: StreamChat(
        client: client,
        child: StreamChannel(
          channel: channel,
          child: Scaffold(
            body: StreamTypingIndicator(
              key: key,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'it should show channel typing',
    (WidgetTester tester) async {
      when(() => channelState.typingEvents).thenAnswer(
        (i) => {
          User(id: 'other-user', name: 'demo'): Event(type: EventType.typingStart),
        },
      );
      when(() => channelState.typingEventsStream).thenAnswer(
        (i) => Stream.value({
          User(id: 'other-user', name: 'demo'): Event(type: EventType.typingStart),
        }),
      );

      const typingKey = Key('typing');

      await tester.pumpWidget(buildTarget(key: typingKey));

      // wait for the initial state to be rendered.
      await tester.pump(Duration.zero);

      expect(find.byKey(typingKey), findsOneWidget);
      expect(find.byType(Flexible), findsOneWidget);
    },
  );

  // Advances the stream event and the 300ms AnimatedSwitcher transition
  // without settling (the typing dots animation repeats forever).
  Future<void> emit(
    WidgetTester tester,
    StreamController<Map<User, Event>> controller,
    Map<User, Event> typingEvents,
  ) async {
    controller.add(typingEvents);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets(
    'it updates as the set of typing users changes',
    (WidgetTester tester) async {
      final typingController = StreamController<Map<User, Event>>.broadcast();
      addTearDown(typingController.close);

      when(() => channelState.typingEvents).thenReturn(const {});
      when(() => channelState.typingEventsStream).thenAnswer(
        (_) => typingController.stream,
      );

      Event event() => Event(type: EventType.typingStart);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreamTypingIndicator(channel: channel),
          ),
        ),
      );
      await tester.pump();

      // No one is typing -> no typing row is shown.
      expect(find.byType(Flexible), findsNothing);

      // A single user is typing -> their name is shown.
      await emit(tester, typingController, {
        User(id: 'user-a', name: 'Alice'): event(),
      });
      expect(find.text('Alice is typing'), findsOneWidget);

      // A second user joins -> the summarized text is shown.
      await emit(tester, typingController, {
        User(id: 'user-a', name: 'Alice'): event(),
        User(id: 'user-b', name: 'Bob'): event(),
      });
      expect(find.text('Alice and 1 more are typing'), findsOneWidget);

      // Everyone stops typing -> the typing row is removed again.
      await emit(tester, typingController, const {});
      expect(find.byType(Flexible), findsNothing);
    },
  );

  testWidgets(
    'it only shows typing users matching its parentId',
    (WidgetTester tester) async {
      final typingController = StreamController<Map<User, Event>>.broadcast();
      addTearDown(typingController.close);

      when(() => channelState.typingEvents).thenReturn(const {});
      when(() => channelState.typingEventsStream).thenAnswer(
        (_) => typingController.stream,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreamTypingIndicator(
              channel: channel,
              parentId: 'thread-1',
            ),
          ),
        ),
      );
      await tester.pump();

      // Typing in the main channel (no parentId) is ignored by a thread
      // indicator.
      await emit(tester, typingController, {
        User(id: 'user-a', name: 'Alice'): Event(type: EventType.typingStart),
      });
      expect(find.byType(Flexible), findsNothing);

      // Typing within the thread is shown.
      await emit(tester, typingController, {
        User(id: 'user-b', name: 'Bob'): Event(
          type: EventType.typingStart,
          parentId: 'thread-1',
        ),
      });
      expect(find.text('Bob is typing'), findsOneWidget);
    },
  );
}
