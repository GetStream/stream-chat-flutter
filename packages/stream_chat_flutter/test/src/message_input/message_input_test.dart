// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox_list_tile.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

class _MockAudioRecorder extends Mock implements AudioRecorder {}

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
              child: Scaffold(
                body: StreamMessageComposer(),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.text('Slow mode, wait 10s\u2026'), findsOneWidget);

      // The text field is locked while slow mode is active.
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);

      // The trailing button shows the remaining cooldown instead of send / mic.
      expect(find.text('10'), findsOneWidget);
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

  group('StreamChatMessageInput hold-to-record snackbar', () {
    late _MockAudioRecorder mockRecorder;
    late StreamAudioRecorderController audioRecorderController;

    setUpAll(() => registerFallbackValue(Duration.zero));

    setUp(() {
      PathProviderPlatform.instance = FakePathProviderPlatform();
      mockRecorder = _MockAudioRecorder();
      // The production AudioRecorder spins up a 100ms periodic amplitude
      // timer; mocking with an empty stream keeps the test binding free
      // of pending timers.
      when(() => mockRecorder.onAmplitudeChanged(any())).thenAnswer((_) => const Stream.empty());
      when(() => mockRecorder.dispose()).thenAnswer((_) async {});

      audioRecorderController = StreamAudioRecorderController.raw(
        recorder: mockRecorder,
        config: const RecordConfig(numChannels: 1),
      );
    });

    testWidgets(
      'long-press cancel on mic shows the hold-to-record snackbar',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            StreamChatMessageInput(
              onSendPressed: () {},
              audioRecorderController: audioRecorderController,
            ),
          ),
        );
        await tester.pumpAndSettle();

        const holdLabel = 'Hold to record. Release to save.';
        expect(find.text(holdLabel), findsNothing);

        await _cancelMicLongPress(tester);

        expect(find.text(holdLabel), findsOneWidget);
        expect(find.byType(StreamSnackbar), findsOneWidget);

        // Dispose in body: showInfo's 3s timer outlives the widget tree, and
        // `tearDown` / `addTearDown` run after the binding's pending-timer
        // check — only a body-side dispose cancels it in time.
        audioRecorderController.dispose();
      },
    );

    testWidgets(
      'invokes onRecordStartCancel feedback before showing the snackbar',
      (WidgetTester tester) async {
        final feedback = _RecordingFeedbackSpy();

        await tester.pumpWidget(
          buildWidget(
            StreamChatMessageInput(
              onSendPressed: () {},
              audioRecorderController: audioRecorderController,
              feedback: feedback,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await _cancelMicLongPress(tester);

        expect(feedback.cancelCount, 1);
        expect(find.text('Hold to record. Release to save.'), findsOneWidget);

        audioRecorderController.dispose();
      },
    );

    testWidgets(
      'rapid cancels do not enqueue duplicate snackbars',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            StreamChatMessageInput(
              onSendPressed: () {},
              audioRecorderController: audioRecorderController,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await _cancelMicLongPress(tester);
        await _cancelMicLongPress(tester);
        await _cancelMicLongPress(tester);

        expect(find.byType(StreamSnackbar), findsOneWidget);

        audioRecorderController.dispose();
      },
    );

    testWidgets(
      'starting a hold clears the in-flight hold-to-record snackbar',
      (WidgetTester tester) async {
        // Mock the recorder so startRecord can transition to RecordStateRecordingHold.
        const config = RecordConfig(numChannels: 1);
        when(() => mockRecorder.hasPermission(request: false)).thenAnswer((_) async => true);
        when(() => mockRecorder.start(config, path: any(named: 'path'))).thenAnswer((_) async {});

        await tester.pumpWidget(
          buildWidget(
            StreamChatMessageInput(
              onSendPressed: () {},
              audioRecorderController: audioRecorderController,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await _cancelMicLongPress(tester);
        expect(find.byType(StreamSnackbar), findsOneWidget);

        // Long-press the mic. startRecord transitions to RecordStateRecordingHold;
        // the listener should react and remove the in-flight hint.
        final mic = find.byKey(const ValueKey('microphone_key'));
        tester.widget<GestureDetector>(mic).onLongPress!();
        // pump < 1s so the recorder's periodic duration timer doesn't tick;
        // microtasks drain and the state transition + listener fire complete.
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byType(StreamSnackbar), findsNothing);
        expect(audioRecorderController.value, isA<RecordStateRecordingHold>());

        audioRecorderController.dispose();
      },
    );

    testWidgets(
      'composer subtree resolves a StreamSnackbarMessenger via context',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            StreamChatMessageInput(
              onSendPressed: () {},
              audioRecorderController: audioRecorderController,
            ),
          ),
        );
        await tester.pumpAndSettle();

        final micContext = tester.element(find.byKey(const ValueKey('microphone_key')));
        expect(StreamSnackbarMessenger.maybeOf(micContext), isNotNull);
      },
    );

    testWidgets(
      'swiping the snackbar away clears the recorder state.message',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(
            StreamChatMessageInput(
              onSendPressed: () {},
              audioRecorderController: audioRecorderController,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // ignore: deprecated_member_use
        audioRecorderController.showInfo('Hint');
        await tester.pumpAndSettle();
        expect(find.text('Hint'), findsOneWidget);
        expect(
          // ignore: deprecated_member_use
          (audioRecorderController.value as RecordStateIdle).message,
          'Hint',
        );

        await tester.fling(find.text('Hint'), const Offset(0, 300), 1000);
        await tester.pumpAndSettle();

        expect(find.byType(StreamSnackbar), findsNothing);
        // The listener should have called hideInfo() on dismissal, so the
        // recorder no longer thinks it's showing 'Hint'. A subsequent
        // showInfo('Hint') should fire a fresh snackbar.
        expect(
          // ignore: deprecated_member_use
          (audioRecorderController.value as RecordStateIdle).message,
          isNull,
        );

        // ignore: deprecated_member_use
        audioRecorderController.showInfo('Hint');
        await tester.pumpAndSettle();
        expect(find.text('Hint'), findsOneWidget);

        audioRecorderController.dispose();
      },
    );
  });

  group('StreamChat global snackbar scope', () {
    testWidgets(
      'descendants without a nearer popup find a fallback messenger',
      (WidgetTester tester) async {
        StreamSnackbarMessenger? captured;

        await tester.pumpWidget(
          buildWidget(
            Builder(
              builder: (context) {
                captured = StreamSnackbarMessenger.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(captured, isNotNull);
      },
    );
  });

  goldenTest(
    'composer hold-to-record snackbar',
    fileName: 'composer_hold_to_record_snackbar',
    constraints: const BoxConstraints.tightFor(width: 400, height: 240),
    pumpBeforeTest: (tester) async {
      await tester.pumpAndSettle();
      final mic = find.byKey(const ValueKey('microphone_key'));
      final gd = tester.widget<GestureDetector>(mic);
      gd.onLongPressCancel!();
      await tester.pumpAndSettle();
    },
    builder: () => buildWidget(
      Column(
        children: [
          const Expanded(child: SizedBox()),
          StreamMessageComposer(),
        ],
      ),
    ),
  );
}

Future<void> _cancelMicLongPress(WidgetTester tester) async {
  final mic = find.byKey(const ValueKey('microphone_key'));
  expect(mic, findsOneWidget);
  // Invoking the callback directly avoids depending on gesture-arena
  // timing — onLongPressCancel needs a sibling tap to race the long press,
  // which is brittle to reproduce in widget tests.
  final gestureDetector = tester.widget<GestureDetector>(mic);
  gestureDetector.onLongPressCancel!();
  await tester.pumpAndSettle();
}

class _RecordingFeedbackSpy extends AudioRecorderFeedback {
  _RecordingFeedbackSpy() : super();

  int cancelCount = 0;

  @override
  Future<void> onRecordStartCancel(BuildContext context) async {
    cancelCount++;
  }
}

MaterialApp buildWidget(Widget input) {
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
      connectivityStream: Stream.value([ConnectivityResult.mobile]),
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
