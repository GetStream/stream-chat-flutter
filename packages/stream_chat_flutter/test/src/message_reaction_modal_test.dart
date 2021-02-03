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
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData();

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final streamTheme = StreamChatThemeData.getDefaultTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
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

      await tester.pump(Duration(milliseconds: 1000));

      expect(find.byKey(Key('MessageWidget')), findsOneWidget);
      expect(find.byKey(Key('StreamSvgIcon-Icon_thumbs_up_reaction.svg')),
          findsOneWidget);
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
                    type: 'like',
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

      await tester.pump(Duration(milliseconds: 1000));
      expect(find.byKey(Key('MessageWidget')), findsOneWidget);
      expect(find.byKey(Key('StreamSvgIcon-Icon_thumbs_up_reaction.svg')),
          findsNWidgets(2));
      expect(find.byKey(Key('StreamSvgIcon-Icon_love_reaction.svg')),
          findsNWidgets(2));
      expect(find.text(testUserId.split(' ')[0]), findsNWidgets(2));
    },
  );
}
