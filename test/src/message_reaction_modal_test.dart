import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/src/message_reactions_modal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show one thumbs from the picker',
    (WidgetTester tester) async {
      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.getDefaultTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChatTheme(
            data: streamTheme,
            child: MessageReactionsModal(
              message: Message(
                id: 'test',
                text: 'test message',
                user: User(
                  id: 'test-user',
                ),
              ),
              messageTheme: streamTheme.ownMessageTheme,
            ),
          ),
        ),
      );

      expect(find.byKey(Key('MessageWidget')), findsOneWidget);
      expect(find.byIcon(StreamIcons.thumbs_up_reaction), findsOneWidget);
    },
  );

  testWidgets(
    'it should show two reactions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.getDefaultTheme(themeData);
      final testUserId = 'test user';

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: MessageReactionsModal(
              message: Message(
                text: 'test message',
                user: User(
                  id: 'test-user',
                ),
                latestReactions: [
                  Reaction(
                    type: 'thumbs_up',
                    user: User(id: testUserId),
                  ),
                  Reaction(
                    type: 'love',
                    user: User(id: testUserId),
                  ),
                ],
              ),
              messageTheme: streamTheme.ownMessageTheme,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(Key('MessageWidget')), findsOneWidget);
      expect(find.byIcon(StreamIcons.thumbs_up_reaction), findsNWidgets(2));
      expect(find.byIcon(StreamIcons.love_reaction), findsNWidgets(2));
      expect(find.text(testUserId), findsNWidgets(2));
    },
  );
}
