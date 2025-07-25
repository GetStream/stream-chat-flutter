import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_actions_modal/message_actions_modal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
        MaterialPageRoute(builder: (context) => const SizedBox()));
    registerFallbackValue(Message());
  });

  testWidgets(
    'it should show the all actions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: StreamChannel(
                channel: channel,
                child: MessageActionsModal(
                  message: Message(
                    text: 'test',
                    user: User(
                      id: 'user-id',
                    ),
                    state: MessageState.sent,
                  ),
                  messageWidget: const Text(
                    'test',
                    key: Key('MessageWidget'),
                  ),
                  messageTheme: streamTheme.ownMessageTheme,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('MessageWidget')), findsOneWidget);
      expect(find.text('Thread Reply'), findsOneWidget);
      expect(find.text('Reply'), findsOneWidget);
      expect(find.text('Edit Message'), findsOneWidget);
      expect(find.text('Delete Message'), findsOneWidget);
      expect(find.text('Copy Message'), findsOneWidget);
      expect(find.text('Mark as Unread'), findsOneWidget);
    },
  );

  testWidgets(
    'it should show the reaction picker',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(
        ownCapabilities: [
          ChannelCapability.sendMessage,
          ChannelCapability.sendReaction,
        ],
      );

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: StreamChannel(
                channel: channel,
                child: MessageActionsModal(
                  message: Message(
                    text: 'test',
                    user: User(
                      id: 'user-id',
                    ),
                    state: MessageState.sent,
                  ),
                  messageWidget: const Text(
                    'test',
                    key: Key('MessageWidget'),
                  ),
                  messageTheme: streamTheme.ownMessageTheme,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StreamReactionPicker), findsOneWidget);
    },
  );

  testWidgets(
    'it should not show the reaction picker',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: StreamChannel(
                channel: channel,
                child: MessageActionsModal(
                  showReactionPicker: false,
                  message: Message(
                    text: 'test',
                    user: User(
                      id: 'user-id',
                    ),
                    state: MessageState.sent,
                  ),
                  messageWidget: const Text(
                    'test',
                    key: Key('MessageWidget'),
                  ),
                  messageTheme: streamTheme.ownMessageTheme,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StreamReactionPicker), findsNothing);
    },
  );

  testWidgets(
    'it should show some actions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: StreamChannel(
                channel: channel,
                child: MessageActionsModal(
                  showCopyMessage: false,
                  showReplyMessage: false,
                  showThreadReplyMessage: false,
                  message: Message(
                    text: 'test',
                    user: User(
                      id: 'user-id',
                    ),
                  ),
                  messageTheme: streamTheme.ownMessageTheme,
                  messageWidget: const Text(
                    'test',
                    key: Key('MessageWidget'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('MessageWidget')), findsOneWidget);
      expect(find.text('Reply'), findsNothing);
      expect(find.text('Thread reply'), findsNothing);
      expect(find.text('Edit message'), findsNothing);
      expect(find.text('Delete message'), findsNothing);
      expect(find.text('Copy message'), findsNothing);
    },
  );

  testWidgets(
    'it should show custom actions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        theme: themeData,
        home: StreamChat(
          streamChatThemeData: streamTheme,
          client: client,
          child: SizedBox(
            child: StreamChannel(
              channel: channel,
              child: StreamChannel(
                channel: channel,
                child: MessageActionsModal(
                  messageWidget: const Text('test'),
                  message: Message(
                    text: 'test',
                    user: User(
                      id: 'user-id',
                    ),
                  ),
                  messageTheme: streamTheme.ownMessageTheme,
                  customActions: [
                    StreamMessageAction(
                      leading: const Icon(Icons.check),
                      title: const Text('title'),
                      onTap: (m) {
                        tapped = true;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('title'), findsOneWidget);

      await tester.tap(find.text('title'));

      expect(tapped, true);
    },
  );

  testWidgets(
    'tapping on reply should call the callback',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: StreamChannel(
                channel: channel,
                child: MessageActionsModal(
                  messageWidget: const Text('test'),
                  onReplyTap: (m) {
                    tapped = true;
                  },
                  message: Message(
                    text: 'test',
                    user: User(
                      id: 'user-id',
                    ),
                    state: MessageState.sent,
                  ),
                  messageTheme: streamTheme.ownMessageTheme,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reply'));

      expect(tapped, true);
    },
  );

  testWidgets(
    'tapping on thread reply should call the callback',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: StreamChannel(
                channel: channel,
                child: MessageActionsModal(
                  messageWidget: const Text('test'),
                  onThreadReplyTap: (m) {
                    tapped = true;
                  },
                  message: Message(
                    text: 'test',
                    user: User(
                      id: 'user-id',
                    ),
                    state: MessageState.sent,
                  ),
                  messageTheme: streamTheme.ownMessageTheme,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Thread Reply'));

      expect(tapped, true);
    },
  );

  testWidgets(
    'tapping on edit should show the edit bottom sheet',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.state).thenReturn(channelState);
      when(channel.getRemainingCooldown).thenReturn(0);

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: Builder(
            builder: (context) => StreamChannel(
              showLoading: false,
              channel: channel,
              child: MessageActionsModal(
                messageWidget: const Text('test'),
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
                onEditMessageTap: (message) => showEditMessageSheet(
                  context: context,
                  message: message,
                  channel: channel,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit Message'));

      await tester.pumpAndSettle();

      expect(find.byType(StreamMessageInput), findsOneWidget);
    },
  );

  testWidgets(
    'tapping on edit should show use the custom builder',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                messageWidget: const Text('test'),
                editMessageInputBuilder: (context, m) => const Text('test'),
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit Message'));

      await tester.pumpAndSettle();

      expect(find.text('test'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping on copy should use the callback',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                messageWidget: const Text('test'),
                onCopyTap: (m) => tapped = true,
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Copy Message'));

      expect(tapped, true);
    },
  );

  testWidgets(
    'tapping on resend should call retry message',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      final message = Message(
        state: MessageState.sendingFailed(
          skipPush: false,
          skipEnrichUrl: false,
        ),
        text: 'test',
        user: User(
          id: 'user-id',
        ),
      );

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.retryMessage(message))
          .thenAnswer((_) async => SendMessageResponse());

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                messageWidget: const Text('test'),
                message: message,
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resend'));

      verify(() => channel.retryMessage(message)).called(1);
    },
  );

  testWidgets(
    'tapping on flag message should show the dialog',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                messageWidget: const Text('test'),
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flag Message'));
      await tester.pumpAndSettle();

      expect(find.text('Flag Message'), findsNWidgets(2));

      await tester.tap(find.text('FLAG'));
      await tester.pumpAndSettle();

      verify(() => client.flagMessage('testid')).called(1);
    },
  );

  testWidgets(
    'if flagging a message throws an error the error dialog should appear',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.flagMessage(any()))
          .thenThrow(StreamChatNetworkError(ChatErrorCode.internalSystemError));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                messageWidget: const Text('test'),
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flag Message'));
      await tester.pumpAndSettle();

      expect(find.text('Flag Message'), findsNWidgets(2));

      await tester.tap(find.text('FLAG'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
    },
  );

  testWidgets(
    'if flagging an already flagged message no error should appear',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.flagMessage(any()))
          .thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                messageWidget: const Text('test'),
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flag Message'));
      await tester.pumpAndSettle();

      expect(find.text('Flag Message'), findsNWidgets(2));

      await tester.tap(find.text('FLAG'));
      await tester.pumpAndSettle();

      expect(find.text('Message flagged'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping on delete message should call client.delete',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                messageWidget: const Text('test'),
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Message'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Message'), findsOneWidget);

      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();

      verify(() => channel.deleteMessage(any())).called(1);
    },
  );

  testWidgets(
    'tapping on delete message should call client.delete',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.deleteMessage(any()))
          .thenThrow(StreamChatNetworkError(ChatErrorCode.internalSystemError));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                messageWidget: const Text('test'),
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Message'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Message'), findsOneWidget);

      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping on unread message should call client.unread',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: Scaffold(
            body: StreamChannel(
              showLoading: false,
              channel: channel,
              child: SizedBox(
                child: MessageActionsModal(
                  messageWidget: const Text('test'),
                  message: Message(
                    id: 'testid',
                    text: 'test',
                    user: User(
                      id: 'user-id',
                    ),
                  ),
                  messageTheme: streamTheme.ownMessageTheme,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mark as Unread'));
      await tester.pumpAndSettle();

      verify(() => channel.markUnread(any())).called(1);
    },
  );
}
