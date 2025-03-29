import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'checks message input features',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(channel.getRemainingCooldown).thenReturn(0);
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
          )
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
        )
      ]);
      when(() => channelState.messagesStream).thenAnswer(
        (i) => Stream.value([
          Message(
            text: 'hello',
            user: User(id: 'other-user'),
          )
        ]),
      );

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: const Scaffold(
              body: StreamMessageInput(),
            ),
          ),
        ),
      ));

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byKey(const Key('messageInputText')), findsOneWidget);
    },
  );

  testWidgets(
    'checks message input slow mode',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(channel.getRemainingCooldown).thenReturn(10);
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
          )
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
        )
      ]);
      when(() => channelState.messagesStream).thenAnswer(
        (i) => Stream.value([
          Message(
            text: 'hello',
            user: User(id: 'other-user'),
          )
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamMessageInput(),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.text('Slow mode ON'), findsOneWidget);
    },
  );

  group('MessageInput keyboard interactions', () {
    final client = MockClient();
    final clientState = MockClientState();
    final channel = MockChannel();
    final channelState = MockChannelState();

    setUp(() {
      registerFallbackValue(Message());

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(channel.getRemainingCooldown).thenReturn(0);
      when(() => channelState.isUpToDate).thenReturn(true);
    });

    testWidgets(
      'should send message when Enter key is pressed on desktop',
      (tester) async {
        when(() => channel.sendMessage(any())).thenAnswer(
          (i) async => SendMessageResponse()
            ..message = Message(
              text: 'Hello world',
            ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: const Scaffold(
                  bottomNavigationBar: StreamMessageInput(),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Add some text to the input field
        final textField = find.byType(StreamMessageInput);
        await tester.enterText(textField, 'Hello world');
        await tester.pump();

        // Simulate pressing Enter key
        await simulateKeyDownEvent(LogicalKeyboardKey.enter, tester: tester);

        await tester.pumpAndSettle();

        // Verify that the message was sent
        verify(() => channel.sendMessage(any())).called(1);
      },
    );

    testWidgets(
      'should not send message when Shift+Enter key is pressed on desktop',
      (tester) async {
        when(() => channel.sendMessage(any())).thenAnswer(
          (_) async => SendMessageResponse()
            ..message = Message(
              text: 'Hello world',
            ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: const Scaffold(
                  bottomNavigationBar: StreamMessageInput(),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Add some text to the input field
        final textField = find.byType(StreamMessageInput);
        await tester.enterText(textField, 'Hello world');
        await tester.pump();

        // Simulate pressing Shift+Enter key
        await simulateKeyDownEvent(
          LogicalKeyboardKey.enter,
          tester: tester,
          isShiftPressed: true,
        );

        await tester.pumpAndSettle();

        // Verify that the message was not sent.
        verifyNever(() => channel.sendMessage(any()));
      },
    );
  });
}

// Helper function to simulate key press events
Future<void> simulateKeyDownEvent(
  LogicalKeyboardKey key, {
  required WidgetTester tester,
  bool isShiftPressed = false,
}) async {
  if (isShiftPressed) {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
  }

  await tester.sendKeyDownEvent(key);
  await tester.pumpAndSettle();
  await tester.sendKeyUpEvent(key);

  if (isShiftPressed) {
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
  }
}
