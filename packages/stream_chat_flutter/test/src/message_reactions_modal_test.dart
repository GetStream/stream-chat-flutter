import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_reactions_modal.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'control test',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final themeData = ThemeData();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      final message = Message(
        id: 'test',
        text: 'test message',
        user: User(
          id: 'test-user',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: StreamChannel(
              channel: channel,
              child: StreamMessageReactionsModal(
                messageWidget: const Text(
                  'test',
                  key: Key('MessageWidget'),
                ),
                message: message,
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.byType(StreamReactionBubble), findsNothing);

      expect(find.byType(StreamUserAvatar), findsNothing);
    },
  );

  testWidgets(
    'it should apply passed parameters',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final themeData = ThemeData();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      final message = Message(
        id: 'test',
        text: 'test message',
        user: User(
          id: 'test-user',
        ),
        latestReactions: [
          Reaction(
            messageId: 'test',
            user: User(id: 'testid'),
            type: 'test',
          ),
        ],
      );

      // ignore: prefer_function_declarations_over_variables
      final onUserAvatarTap = (u) => print('ok');

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: StreamChannel(
              channel: channel,
              child: StreamMessageReactionsModal(
                messageWidget: const Text(
                  'test',
                  key: Key('MessageWidget'),
                ),
                message: message,
                messageTheme: streamTheme.ownMessageTheme,
                reverse: true,
                showReactions: false,
                onUserAvatarTap: onUserAvatarTap,
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.byKey(const Key('MessageWidget')), findsOneWidget);

      expect(find.byType(StreamReactionBubble), findsOneWidget);
      expect(find.byType(StreamUserAvatar), findsOneWidget);
    },
  );
}
