// ignore_for_file: lines_longer_than_80_chars

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox_list_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

/// TODO: remove skip once we have a proper message input test.
void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  testWidgets(
    'checks message input features',
    skip: true,
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          const StreamMessageInput(),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byKey(const Key('messageInputText')), findsOneWidget);
    },
  );

  testWidgets(
    'checks message input slow mode',
    skip: true,
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

  testWidgets(
    'allows setting padding on message input',
    skip: true,
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          const StreamMessageInput(
            padding: EdgeInsets.only(left: 50),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(StreamMessageValueListenableBuilder),
          matching: find.byWidgetPredicate((w) => w is Padding && w.padding == const EdgeInsets.only(left: 50)),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'allows setting explicit margin on text field',
    skip: true,
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          const StreamMessageInput(
            textInputMargin: EdgeInsets.only(left: 50),
          ),
        ),
      );
      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(DropTarget),
          matching: find.byWidgetPredicate((w) => w is Container && w.margin == const EdgeInsets.only(left: 50)),
        ),
        findsOneWidget,
      );
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
      when(() => clientState.currentUserStream).thenAnswer(
        (_) => Stream.value(OwnUser(id: 'user-id')),
      );

      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(channel.getRemainingCooldown).thenReturn(0);
      when(() => channelState.isUpToDate).thenReturn(true);
    });

    testWidgets(
      'should send message when Enter key is pressed on desktop',
      skip: true,
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
        final textField = find.byType(StreamMessageTextField);
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
      skip: true,
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
        final textField = find.byType(StreamMessageTextField);
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

    testWidgets(
      'should clear quoted message when Esc key is pressed on desktop',
      skip: true,
      (tester) async {
        final quotedMessage = Message(text: 'I am a quoted message');
        final initialMessage = Message(quotedMessage: quotedMessage);

        final messageInputController = StreamMessageInputController(
          message: initialMessage,
        );

        var onQuotedMessageClearedCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  bottomNavigationBar: StreamMessageInput(
                    messageInputController: messageInputController,
                    onQuotedMessageCleared: () {
                      onQuotedMessageClearedCalled = true;
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Tap the message input to focus it
        final textField = find.byType(StreamMessageTextField);
        await tester.tap(textField);
        await tester.pump();

        // Simulate pressing Escape key
        await simulateKeyDownEvent(LogicalKeyboardKey.escape, tester: tester);

        await tester.pumpAndSettle();

        // Verify that the onQuotedMessageCleared callback was called
        expect(onQuotedMessageClearedCalled, isTrue);
      },
    );

    testWidgets(
      'should not clear quoted message contains text and Esc key is pressed on desktop',
      skip: true,
      (tester) async {
        final quotedMessage = Message(text: 'I am a quoted message');
        final initialMessage = Message(quotedMessage: quotedMessage);

        final messageInputController = StreamMessageInputController(
          message: initialMessage,
        );

        var onQuotedMessageClearedCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  bottomNavigationBar: StreamMessageInput(
                    messageInputController: messageInputController,
                    onQuotedMessageCleared: () {
                      onQuotedMessageClearedCalled = true;
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Add some text to the input field
        final textField = find.byType(StreamMessageTextField);
        await tester.enterText(textField, 'Hello world');
        await tester.pump();

        // Simulate pressing Enter key
        await simulateKeyDownEvent(LogicalKeyboardKey.escape, tester: tester);

        await tester.pumpAndSettle();

        // Verify that the onQuotedMessageCleared callback was not called
        expect(onQuotedMessageClearedCalled, isFalse);
      },
    );
  });

  group('DmCheckboxListTile integration in MessageInput', () {
    final client = MockClient();
    final clientState = MockClientState();
    final channel = MockChannel();
    final channelState = MockChannelState();

    setUp(() {
      registerFallbackValue(Message());

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.currentUserStream).thenAnswer(
        (_) => Stream.value(OwnUser(id: 'user-id')),
      );

      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(channel.getRemainingCooldown).thenReturn(0);
      when(() => channelState.isUpToDate).thenReturn(true);
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

    testWidgets(
      'should not show DmCheckboxListTile when hideSendAsDm is true',
      skip: true,
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: const Scaffold(
                  bottomNavigationBar: StreamMessageInput(
                    hideSendAsDm: true,
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(DmCheckboxListTile), findsNothing);
      },
    );

    testWidgets(
      'should not show DmCheckboxListTile when not in a thread',
      skip: true,
      (tester) async {
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

        expect(find.byType(DmCheckboxListTile), findsNothing);
      },
    );

    testWidgets(
      'should show DmCheckboxListTile when in a thread and hideSendAsDm is false',
      skip: true,
      (tester) async {
        // Set up a message controller with a parent message ID (thread)
        final messageInputController = StreamMessageInputController(
          message: Message(parentId: 'parent-message-id'),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  bottomNavigationBar: StreamMessageInput(
                    messageInputController: messageInputController,
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(DmCheckboxListTile), findsOneWidget);
      },
    );

    testWidgets(
      'should toggle showInChannel value when DmCheckboxListTile is tapped',
      skip: true,
      (tester) async {
        // Set up a message controller with a parent message ID (thread)
        final messageInputController = StreamMessageInputController(
          message: Message(parentId: 'parent-message-id'),
        );

        addTearDown(messageInputController.dispose);

        // Initial value should be false
        expect(messageInputController.showInChannel, false);

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  bottomNavigationBar: StreamMessageInput(
                    messageInputController: messageInputController,
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find and tap the checkbox
        await tester.tap(find.byType(DmCheckboxListTile));
        await tester.pumpAndSettle();

        // Value should now be true
        expect(messageInputController.showInChannel, true);

        // Tap again to toggle it back to false
        await tester.tap(find.byType(DmCheckboxListTile));
        await tester.pumpAndSettle();

        // Value should now be false again
        expect(messageInputController.showInChannel, false);
      },
    );
  });
}

MaterialApp buildWidget(StreamMessageInput input) {
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

  return MaterialApp(
    home: StreamChat(
      client: client,
      child: StreamChannel(
        channel: channel,
        child: Scaffold(body: input),
      ),
    ),
  );
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
