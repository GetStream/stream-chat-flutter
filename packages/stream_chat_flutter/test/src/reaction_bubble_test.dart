import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';
import 'simple_frame.dart';

void main() {
  testGoldens(
    'it should show no reactions',
    (WidgetTester tester) async {
      await tester.pumpWidgetBuilder(
        SimpleFrame(
          child: StreamChatTheme(
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
        surfaceSize: Size(100, 100),
      );
      await screenMatchesGolden(tester, 'reaction_bubble_0');
    },
  );

  testGoldens(
    'it should show a like - light theme',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData.light();

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final theme = StreamChatThemeData.getDefaultTheme(themeData);
      await tester.pumpWidgetBuilder(
        StreamChat(
          client: client,
          streamChatThemeData: theme,
          child: Container(
            child: ReactionBubble(
              reactions: [
                Reaction(
                  type: 'like',
                  user: User(id: 'test'),
                ),
              ],
              borderColor: theme.ownMessageTheme.reactionsBorderColor,
              backgroundColor: theme.ownMessageTheme.reactionsBackgroundColor,
              maskColor: theme.ownMessageTheme.reactionsMaskColor,
            ),
          ),
        ),
        surfaceSize: Size(100, 100),
      );
      await screenMatchesGolden(tester, 'reaction_bubble_like_light');
    },
  );

  testGoldens(
    'it should show a like - dark theme',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData.dark();
      final theme = StreamChatThemeData.getDefaultTheme(themeData);

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidgetBuilder(
        StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.getDefaultTheme(themeData),
          child: Container(
            color: Colors.black,
            child: ReactionBubble(
              reactions: [
                Reaction(
                  type: 'like',
                  user: User(id: 'test'),
                ),
              ],
              borderColor: theme.ownMessageTheme.reactionsBorderColor,
              backgroundColor: theme.ownMessageTheme.reactionsBackgroundColor,
              maskColor: theme.ownMessageTheme.reactionsMaskColor,
            ),
          ),
        ),
        surfaceSize: Size(100, 100),
      );
      await screenMatchesGolden(tester, 'reaction_bubble_like_dark');
    },
  );

  testGoldens(
    'it should show three reactions - light theme',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData.light();
      final theme = StreamChatThemeData.getDefaultTheme(themeData);

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidgetBuilder(
        StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.getDefaultTheme(themeData),
          child: Container(
            color: Colors.black,
            child: ReactionBubble(
              reactions: [
                Reaction(
                  type: 'like',
                  user: User(id: 'test'),
                ),
                Reaction(
                  type: 'like',
                  user: User(id: 'user-id'),
                ),
                Reaction(
                  type: 'like',
                  user: User(id: 'test'),
                ),
              ],
              borderColor: theme.ownMessageTheme.reactionsBorderColor,
              backgroundColor: theme.ownMessageTheme.reactionsBackgroundColor,
              maskColor: theme.ownMessageTheme.reactionsMaskColor,
            ),
          ),
        ),
        surfaceSize: Size(140, 140),
      );
      await screenMatchesGolden(tester, 'reaction_bubble_3_light');
    },
  );

  testGoldens(
    'it should show three reactions - dark theme',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData.dark();
      final theme = StreamChatThemeData.getDefaultTheme(themeData);

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidgetBuilder(
        StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.getDefaultTheme(themeData),
          child: Container(
            color: Colors.black,
            child: ReactionBubble(
              reactions: [
                Reaction(
                  type: 'like',
                  user: User(id: 'test'),
                ),
                Reaction(
                  type: 'like',
                  user: User(id: 'user-id'),
                ),
                Reaction(
                  type: 'like',
                  user: User(id: 'test'),
                ),
              ],
              borderColor: theme.ownMessageTheme.reactionsBorderColor,
              backgroundColor: theme.ownMessageTheme.reactionsBackgroundColor,
              maskColor: theme.ownMessageTheme.reactionsMaskColor,
            ),
          ),
        ),
        surfaceSize: Size(140, 140),
      );
      await screenMatchesGolden(tester, 'reaction_bubble_3_dark');
    },
  );

  testGoldens(
    'it should show two reactions with customized ui',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData();

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidgetBuilder(
        StreamChat(
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
                  user: User(id: 'user-id'),
                ),
                Reaction(
                  type: 'unknown',
                  user: User(id: 'test'),
                ),
              ],
              borderColor: Colors.red,
              backgroundColor: Colors.blue,
              maskColor: Colors.green,
              highlightOwnReactions: true,
              reverse: true,
              flipTail: true,
              tailCirclesSpacing: 4,
            ),
          ),
        ),
        surfaceSize: Size(200, 200),
      );

      await screenMatchesGolden(tester, 'reaction_bubble_2');
    },
  );
}
