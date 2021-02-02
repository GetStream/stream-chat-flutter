import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show no reactions',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(),
            child: Container(
              child: ReactionBubble(
                reactions: [],
                borderColor: Colors.black,
                backgroundColor: Colors.white,
                maskColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('StreamSvgIcon-Icon_thumbs_up_reaction.svg')),
          findsNothing);
    },
  );

  testWidgets(
    'it should show a like',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData();

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            client: client,
            streamChatThemeData: StreamChatThemeData.getDefaultTheme(themeData),
            child: Container(
              child: ReactionBubble(
                reactions: [
                  Reaction(
                    type: 'like',
                    user: User(id: 'test'),
                  ),
                ],
                borderColor: Colors.black,
                backgroundColor: Colors.white,
                maskColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('StreamSvgIcon-Icon_thumbs_up_reaction.svg')),
          findsOneWidget);
    },
  );
  testWidgets(
    'it should show two reactions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData();

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            client: client,
            streamChatThemeData: StreamChatThemeData.getDefaultTheme(themeData),
            child: Container(
              child: ReactionBubble(
                reactions: [
                  Reaction(
                    type: 'like',
                    user: User(id: 'test'),
                  ),
                  Reaction(
                    type: 'love',
                    user: User(id: 'test'),
                  ),
                ],
                borderColor: Colors.black,
                backgroundColor: Colors.white,
                maskColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(Key('StreamSvgIcon-Icon_thumbs_up_reaction.svg')),
          findsOneWidget);
      expect(find.byKey(Key('StreamSvgIcon-Icon_love_reaction.svg')),
          findsOneWidget);
    },
  );
}
