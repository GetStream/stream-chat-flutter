// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';
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
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          StreamMessageComposer(),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    },
  );

  group('MessageComposer cooldown', () {
    const cooldownSeconds = 10;

    final client = MockClient();
    final clientState = MockClientState();
    final channel = MockChannel();
    final channelState = MockChannelState();

    late BehaviorSubject<DateTime?> lastMessageAtSubject;

    setUp(() {
      registerFallbackValue(Message());
      lastMessageAtSubject = BehaviorSubject<DateTime?>.seeded(null);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));

      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.currentUserLastMessageAtStream).thenAnswer((_) => lastMessageAtSubject.stream);

      // Routes a message added to channel state through the same signal a
      // real channel emits on: the current user's last-message-at stream
      // gets the new timestamp.
      when(() => channelState.addNewMessage(any())).thenAnswer((invocation) {
        final message = invocation.positionalArguments[0] as Message;
        if (message.user?.id == 'user-id' && !message.isEphemeral) {
          lastMessageAtSubject.add(message.createdAt);
        }
      });

      // Real-flow cooldown: derived from the timestamp the LLC stream emits.
      // null (no send yet) → 0, recent timestamp (current user just sent) → cooldownSeconds.
      when(() => channel.getRemainingCooldown(lastMessageAt: any(named: 'lastMessageAt'))).thenAnswer((i) {
        return i.namedArguments[#lastMessageAt] != null ? cooldownSeconds : 0;
      });
    });

    tearDown(() => lastMessageAtSubject.close());

    Future<void> pumpComposer(WidgetTester tester) {
      return tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(body: StreamMessageComposer()),
            ),
          ),
        ),
      );
    }

    Message ownMessage() {
      return Message(
        id: 'msg-1',
        createdAt: DateTime.timestamp(),
        user: User(id: 'user-id'),
      );
    }

    testWidgets(
      'shows slow mode UI when the current user has recently sent a message',
      (tester) async {
        // The user sent a message before the composer mounts — channel cooldown
        // is already active.
        channelState.addNewMessage(ownMessage());

        await pumpComposer(tester);
        await tester.pumpAndSettle();

        expect(find.text('Slow mode, wait ${cooldownSeconds}s…'), findsOneWidget);

        final inputField = tester.widget<StreamMessageComposerInputField>(
          find.byType(StreamMessageComposerInputField),
        );

        // Composer input field is locked while slow mode is active.
        expect(inputField.enabled, isFalse);

        final attachmentButton = tester.widget<StreamButton>(
          find.descendant(
            of: find.byType(DefaultStreamMessageComposerLeading),
            matching: find.byType(StreamButton),
          ),
        );

        // Attachment picker button is disabled while slow mode is active.
        expect(attachmentButton.props.onPressed, isNull);

        // Trailing button shows the remaining cooldown instead of send / mic.
        expect(find.text('$cooldownSeconds'), findsOneWidget);
      },
    );

    testWidgets(
      'does not show slow mode UI when the current user has not sent recently',
      (tester) async {
        // No prior send — channel cooldown is not active on mount.
        await pumpComposer(tester);
        await tester.pumpAndSettle();

        expect(find.text('Slow mode, wait ${cooldownSeconds}s…'), findsNothing);

        final inputField = tester.widget<StreamMessageComposerInputField>(
          find.byType(StreamMessageComposerInputField),
        );

        // Composer input field is enabled when slow mode is not active.
        expect(inputField.enabled, isTrue);

        final attachmentButton = tester.widget<StreamButton>(
          find.descendant(
            of: find.byType(DefaultStreamMessageComposerLeading),
            matching: find.byType(StreamButton),
          ),
        );

        // Attachment picker button is enabled when slow mode is not active.
        expect(attachmentButton.props.onPressed, isNotNull);
      },
    );

    testWidgets(
      'starts cooldown when a sibling composer sends a message (e.g. thread composer)',
      (tester) async {
        await pumpComposer(tester);
        await tester.pumpAndSettle();

        // Before a message is added, no cooldown UI.
        expect(find.text('Slow mode, wait ${cooldownSeconds}s…'), findsNothing);

        // Simulate a sibling composer (e.g. thread composer) adding a message
        // to channel state.
        channelState.addNewMessage(ownMessage());
        await tester.pumpAndSettle();

        expect(find.text('Slow mode, wait ${cooldownSeconds}s…'), findsOneWidget);
      },
    );
  });

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
                child: Scaffold(
                  bottomNavigationBar: StreamMessageComposer(),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Add some text to the input field
        final textField = find.byType(TextField);
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
                child: Scaffold(
                  bottomNavigationBar: StreamMessageComposer(),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Add some text to the input field
        final textField = find.byType(TextField);
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
      (tester) async {
        final quotedMessage = Message(text: 'I am a quoted message');
        final initialMessage = Message(quotedMessage: quotedMessage);

        final messageInputController = StreamMessageComposerController(
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
                  bottomNavigationBar: StreamMessageComposer(
                    messageComposerController: messageInputController,
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
        final textField = find.byType(TextField);
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
      (tester) async {
        final quotedMessage = Message(text: 'I am a quoted message');
        final initialMessage = Message(quotedMessage: quotedMessage);

        final messageInputController = StreamMessageComposerController(
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
                  bottomNavigationBar: StreamMessageComposer(
                    messageComposerController: messageInputController,
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
        final textField = find.byType(TextField);
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

  group('Edit message routing', () {
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
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));
      when(() => channel.extraData).thenReturn({'name': 'test'});
      when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': 'test'}));
      when(() => channelState.isUpToDate).thenReturn(true);
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => channelState.membersStream).thenAnswer(
        (_) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          ),
        ]),
      );
      when(() => channelState.messages).thenReturn([]);
      when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
    });

    testWidgets(
      'calls updateMessage when controller is in edit state',
      (tester) async {
        when(() => channel.updateMessage(any())).thenAnswer(
          (_) async => UpdateMessageResponse()..message = Message(id: 'msg-1', text: 'Edited text'),
        );

        final existingMessage = Message(
          id: 'msg-1',
          text: 'Original text',
          createdAt: DateTime.now(),
        );

        final messageInputController = StreamMessageComposerController()..editMessage(existingMessage);
        addTearDown(messageInputController.dispose);

        final key = GlobalKey<DefaultStreamMessageComposerState>();

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  bottomNavigationBar: DefaultStreamMessageComposer(
                    key: key,
                    props: MessageComposerProps(
                      messageComposerController: messageInputController,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await key.currentState!.sendMessage();
        // Pump past the debounce/throttle timers (350ms)
        await tester.pump(const Duration(seconds: 1));

        verify(() => channel.updateMessage(any())).called(1);
        verifyNever(() => channel.sendMessage(any()));
      },
    );

    testWidgets(
      'calls sendMessage when controller is in normal (non-edit) state',
      (tester) async {
        when(() => channel.sendMessage(any())).thenAnswer(
          (_) async => SendMessageResponse()..message = Message(text: 'Hello'),
        );

        final messageInputController = StreamMessageComposerController(
          message: Message(text: 'Hello'),
        );
        addTearDown(messageInputController.dispose);

        final key = GlobalKey<DefaultStreamMessageComposerState>();

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  bottomNavigationBar: DefaultStreamMessageComposer(
                    key: key,
                    props: MessageComposerProps(
                      messageComposerController: messageInputController,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await key.currentState!.sendMessage();
        // Pump past the debounce/throttle timers (350ms)
        await tester.pump(const Duration(seconds: 1));

        verify(() => channel.sendMessage(any())).called(1);
        verifyNever(() => channel.updateMessage(any()));
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
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  bottomNavigationBar: StreamMessageComposer(
                    canAlsoSendToChannelFromThread: false,
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
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  bottomNavigationBar: StreamMessageComposer(),
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
      (tester) async {
        // Set up a message controller with a parent message ID (thread)
        final messageInputController = StreamMessageComposerController(
          message: Message(parentId: 'parent-message-id'),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: StreamChannel(
                channel: channel,
                child: Scaffold(
                  bottomNavigationBar: StreamMessageComposer(
                    messageComposerController: messageInputController,
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
      (tester) async {
        // Set up a message controller with a parent message ID (thread)
        final messageInputController = StreamMessageComposerController(
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
                  bottomNavigationBar: StreamMessageComposer(
                    messageComposerController: messageInputController,
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

  group('Composer sync with remote events', () {
    late MockClient client;
    late MockClientState clientState;
    late MockChannel channel;
    late MockChannelState channelState;
    late StreamController<Event> eventController;

    setUp(() {
      registerFallbackValue(Message());

      eventController = StreamController<Event>.broadcast();

      client = MockClient();
      clientState = MockClientState();
      channel = MockChannel(eventStream: eventController.stream);
      channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.currentUserStream).thenAnswer(
        (_) => Stream.value(OwnUser(id: 'user-id')),
      );

      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(channel.getRemainingCooldown).thenReturn(0);
      when(() => channelState.isUpToDate).thenReturn(true);
      when(() => channelState.members).thenReturn([]);
      when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
      when(() => channelState.messages).thenReturn([]);
      when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
    });

    tearDown(() => eventController.close());

    group('quoted message', () {
      testWidgets(
        'clears quoted message on message.deleted event',
        (tester) async {
          final quotedMessage = Message(
            id: 'quoted-msg-id',
            text: 'Original message',
            user: User(id: 'other-user'),
          );
          final controller = StreamMessageComposerController(
            message: Message(
              quotedMessage: quotedMessage,
              quotedMessageId: quotedMessage.id,
            ),
          );
          addTearDown(controller.dispose);

          var onQuotedMessageClearedCalled = false;

          await tester.pumpWidget(
            MaterialApp(
              home: StreamChat(
                client: client,
                child: StreamChannel(
                  channel: channel,
                  child: Scaffold(
                    bottomNavigationBar: StreamMessageComposer(
                      messageComposerController: controller,
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

          expect(controller.message.quotedMessageId, 'quoted-msg-id');

          eventController.add(
            Event(
              type: EventType.messageDeleted,
              message: Message(id: 'quoted-msg-id'),
            ),
          );
          await tester.pump();

          expect(onQuotedMessageClearedCalled, isTrue);
        },
      );

      testWidgets(
        'does not clear quoted message when a different message is deleted',
        (tester) async {
          final quotedMessage = Message(
            id: 'quoted-msg-id',
            text: 'Original message',
            user: User(id: 'other-user'),
          );
          final controller = StreamMessageComposerController(
            message: Message(
              quotedMessage: quotedMessage,
              quotedMessageId: quotedMessage.id,
            ),
          );
          addTearDown(controller.dispose);

          var onQuotedMessageClearedCalled = false;

          await tester.pumpWidget(
            MaterialApp(
              home: StreamChat(
                client: client,
                child: StreamChannel(
                  channel: channel,
                  child: Scaffold(
                    bottomNavigationBar: StreamMessageComposer(
                      messageComposerController: controller,
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

          eventController.add(
            Event(
              type: EventType.messageDeleted,
              message: Message(id: 'some-other-msg-id'),
            ),
          );
          await tester.pump();

          expect(controller.message.quotedMessageId, 'quoted-msg-id');
          expect(controller.message.quotedMessage, isNotNull);
          expect(onQuotedMessageClearedCalled, isFalse);
        },
      );

      testWidgets(
        'updates quoted message on message.updated event',
        (tester) async {
          final quotedMessage = Message(
            id: 'quoted-msg-id',
            text: 'Original text',
            user: User(id: 'other-user'),
          );
          final controller = StreamMessageComposerController(
            message: Message(
              quotedMessage: quotedMessage,
              quotedMessageId: quotedMessage.id,
            ),
          );
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            MaterialApp(
              home: StreamChat(
                client: client,
                child: StreamChannel(
                  channel: channel,
                  child: Scaffold(
                    bottomNavigationBar: StreamMessageComposer(
                      messageComposerController: controller,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(controller.message.quotedMessage?.text, 'Original text');

          eventController.add(
            Event(
              type: EventType.messageUpdated,
              message: Message(
                id: 'quoted-msg-id',
                text: 'Edited text',
                user: User(id: 'other-user'),
              ),
            ),
          );
          await tester.pump();

          expect(controller.message.quotedMessageId, 'quoted-msg-id');
          expect(controller.message.quotedMessage?.text, 'Edited text');
        },
      );

      testWidgets(
        'does not update quoted message when a different message is updated',
        (tester) async {
          final quotedMessage = Message(
            id: 'quoted-msg-id',
            text: 'Original text',
            user: User(id: 'other-user'),
          );
          final controller = StreamMessageComposerController(
            message: Message(
              quotedMessage: quotedMessage,
              quotedMessageId: quotedMessage.id,
            ),
          );
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            MaterialApp(
              home: StreamChat(
                client: client,
                child: StreamChannel(
                  channel: channel,
                  child: Scaffold(
                    bottomNavigationBar: StreamMessageComposer(
                      messageComposerController: controller,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          eventController.add(
            Event(
              type: EventType.messageUpdated,
              message: Message(
                id: 'some-other-msg-id',
                text: 'Edited text',
                user: User(id: 'other-user'),
              ),
            ),
          );
          await tester.pump();

          expect(controller.message.quotedMessage?.text, 'Original text');
        },
      );
    });

    group('editing message', () {
      testWidgets(
        'refreshes editing message on message.updated event',
        (tester) async {
          final existingMessage = Message(
            id: 'editing-msg-id',
            text: 'Original text',
            user: User(id: 'user-id'),
          );
          final controller = StreamMessageComposerController()..editMessage(existingMessage);
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            MaterialApp(
              home: StreamChat(
                client: client,
                child: StreamChannel(
                  channel: channel,
                  child: Scaffold(
                    bottomNavigationBar: StreamMessageComposer(
                      messageComposerController: controller,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(controller.message.id, 'editing-msg-id');
          expect(controller.message.text, 'Original text');

          eventController.add(
            Event(
              type: EventType.messageUpdated,
              message: Message(
                id: 'editing-msg-id',
                text: 'Updated by another device',
                user: User(id: 'user-id'),
              ),
            ),
          );
          await tester.pump();

          expect(controller.message.id, 'editing-msg-id');
          expect(controller.message.text, 'Updated by another device');
        },
      );

      testWidgets(
        'does not refresh editing message when a different message is updated',
        (tester) async {
          final existingMessage = Message(
            id: 'editing-msg-id',
            text: 'Original text',
            user: User(id: 'user-id'),
          );
          final controller = StreamMessageComposerController()..editMessage(existingMessage);
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            MaterialApp(
              home: StreamChat(
                client: client,
                child: StreamChannel(
                  channel: channel,
                  child: Scaffold(
                    bottomNavigationBar: StreamMessageComposer(
                      messageComposerController: controller,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          eventController.add(
            Event(
              type: EventType.messageUpdated,
              message: Message(
                id: 'some-other-msg-id',
                text: 'Edited text',
                user: User(id: 'other-user'),
              ),
            ),
          );
          await tester.pump();

          expect(controller.message.text, 'Original text');
        },
      );

      testWidgets(
        'cancels edit on message.deleted event',
        (tester) async {
          final existingMessage = Message(
            id: 'editing-msg-id',
            text: 'Being edited',
            user: User(id: 'user-id'),
          );
          final controller = StreamMessageComposerController()..editMessage(existingMessage);
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            MaterialApp(
              home: StreamChat(
                client: client,
                child: StreamChannel(
                  channel: channel,
                  child: Scaffold(
                    bottomNavigationBar: StreamMessageComposer(
                      messageComposerController: controller,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(controller.message.id, 'editing-msg-id');
          expect(controller.message.state.isUpdating, isTrue);

          eventController.add(
            Event(
              type: EventType.messageDeleted,
              message: Message(id: 'editing-msg-id'),
            ),
          );
          await tester.pump();

          expect(controller.message.id, isNot('editing-msg-id'));
          expect(controller.message.state.isInitial, isTrue);
        },
      );

      testWidgets(
        'does not cancel edit when a different message is deleted',
        (tester) async {
          final existingMessage = Message(
            id: 'editing-msg-id',
            text: 'Being edited',
            user: User(id: 'user-id'),
          );
          final controller = StreamMessageComposerController()..editMessage(existingMessage);
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            MaterialApp(
              home: StreamChat(
                client: client,
                child: StreamChannel(
                  channel: channel,
                  child: Scaffold(
                    bottomNavigationBar: StreamMessageComposer(
                      messageComposerController: controller,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          eventController.add(
            Event(
              type: EventType.messageDeleted,
              message: Message(id: 'some-other-msg-id'),
            ),
          );
          await tester.pump();

          expect(controller.message.id, 'editing-msg-id');
          expect(controller.message.state.isUpdating, isTrue);
        },
      );
    });
  });
}

MaterialApp buildWidget(StreamMessageComposer input) {
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
