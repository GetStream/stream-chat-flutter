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
      final themeData = ThemeData();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

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
            child: MessageReactionsModal(
              message: message,
              messageTheme: streamTheme.ownMessageTheme,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.byType(MessageWidget), findsOneWidget);
      final messageWidget =
          tester.widget<MessageWidget>(find.byType(MessageWidget));
      expect(messageWidget.message, message);
      expect(messageWidget.messageTheme, streamTheme.ownMessageTheme);
      expect(messageWidget.attachmentBorderRadiusGeometry, null);
      expect(messageWidget.showUserAvatar, DisplayWidget.show);
      expect(messageWidget.reverse, false);
      expect(messageWidget.attachmentShape, null);
      expect(messageWidget.shape, null);
      expect(messageWidget.onUserAvatarTap, null);
      expect(messageWidget.showReactions, false);
      expect(messageWidget.showUsername, false);
      expect(messageWidget.showThreadReplyIndicator, false);
      expect(messageWidget.showTimestamp, false);
      expect(messageWidget.translateUserAvatar, false);
      expect(messageWidget.showSendingIndicator, false);

      expect(find.byType(ReactionBubble), findsNothing);

      //only one avatar (the message one)
      expect(find.byType(UserAvatar), findsOneWidget);
    },
  );

  testWidgets(
    'it should apply passed parameters',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

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
            child: MessageReactionsModal(
              message: message,
              messageTheme: streamTheme.ownMessageTheme,
              showUserAvatar: DisplayWidget.gone,
              reverse: true,
              attachmentBorderRadiusGeometry: BorderRadius.circular(1),
              attachmentShape: const RoundedRectangleBorder(),
              showReactions: false,
              messageShape: const RoundedRectangleBorder(),
              onUserAvatarTap: onUserAvatarTap,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 1000));

      expect(find.byType(MessageWidget), findsOneWidget);
      final messageWidget =
          tester.widget<MessageWidget>(find.byType(MessageWidget));
      expect(messageWidget.message, message);
      expect(messageWidget.messageTheme, streamTheme.ownMessageTheme);
      expect(messageWidget.attachmentBorderRadiusGeometry,
          BorderRadius.circular(1));
      expect(messageWidget.showUserAvatar, DisplayWidget.gone);
      expect(messageWidget.reverse, true);
      expect(messageWidget.showReactions, false);
      expect(messageWidget.attachmentShape, const RoundedRectangleBorder());
      expect(messageWidget.shape, const RoundedRectangleBorder());
      expect(messageWidget.showReactions, false);
      expect(messageWidget.showUsername, false);
      expect(messageWidget.showThreadReplyIndicator, false);
      expect(messageWidget.showTimestamp, false);
      expect(messageWidget.translateUserAvatar, false);
      expect(messageWidget.showSendingIndicator, false);

      final userAvatar = tester.widget<UserAvatar>(find.byType(UserAvatar));
      expect(userAvatar.onTap, onUserAvatarTap);

      expect(find.byType(ReactionBubble), findsOneWidget);
      expect(find.byType(UserAvatar), findsOneWidget);
    },
  );
}
