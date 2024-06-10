import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reaction_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  testGoldens(
    'it should show a like - light theme',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData.light(
        useMaterial3: false,
      );

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final theme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidgetBuilder(
        StreamChat(
          client: client,
          streamChatThemeData: theme,
          connectivityStream: Stream.value(ConnectivityResult.mobile),
          child: Scaffold(
            body: Center(
              child: StreamReactionBubble(
                reactions: [
                  Reaction(
                    type: 'like',
                    user: User(id: 'test'),
                  ),
                ],
                borderColor: theme.ownMessageTheme.reactionsBorderColor!,
                backgroundColor:
                    theme.ownMessageTheme.reactionsBackgroundColor!,
                maskColor: theme.ownMessageTheme.reactionsMaskColor!,
              ),
            ),
          ),
        ),
        surfaceSize: const Size(100, 100),
        wrapper: (child) => MaterialAppWrapper(
          theme: themeData,
          home: child,
        ),
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
      final theme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidgetBuilder(
        StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.fromTheme(themeData),
          connectivityStream: Stream.value(ConnectivityResult.mobile),
          child: ColoredBox(
            color: Colors.black,
            child: StreamReactionBubble(
              reactions: [
                Reaction(
                  type: 'like',
                  user: User(id: 'test'),
                ),
              ],
              borderColor: theme.ownMessageTheme.reactionsBorderColor!,
              backgroundColor: theme.ownMessageTheme.reactionsBackgroundColor!,
              maskColor: theme.ownMessageTheme.reactionsMaskColor!,
            ),
          ),
        ),
        surfaceSize: const Size(100, 100),
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
      final theme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidgetBuilder(
        StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.fromTheme(themeData),
          connectivityStream: Stream.value(ConnectivityResult.mobile),
          child: ColoredBox(
            color: Colors.black,
            child: StreamReactionBubble(
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
              borderColor: theme.ownMessageTheme.reactionsBorderColor!,
              backgroundColor: theme.ownMessageTheme.reactionsBackgroundColor!,
              maskColor: theme.ownMessageTheme.reactionsMaskColor!,
            ),
          ),
        ),
        surfaceSize: const Size(140, 140),
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
      final theme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidgetBuilder(
        StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.fromTheme(themeData),
          connectivityStream: Stream.value(ConnectivityResult.mobile),
          child: ColoredBox(
            color: Colors.black,
            child: StreamReactionBubble(
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
              borderColor: theme.ownMessageTheme.reactionsBorderColor!,
              backgroundColor: theme.ownMessageTheme.reactionsBackgroundColor!,
              maskColor: theme.ownMessageTheme.reactionsMaskColor!,
            ),
          ),
        ),
        surfaceSize: const Size(140, 140),
      );
      await screenMatchesGolden(tester, 'reaction_bubble_3_dark');
    },
  );

  testGoldens(
    'it should show two reactions with customized ui',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData(
        useMaterial3: false,
      );

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidgetBuilder(
        StreamChat(
          client: client,
          connectivityStream: Stream.value(ConnectivityResult.mobile),
          streamChatThemeData: StreamChatThemeData.fromTheme(themeData),
          child: Scaffold(
            body: Center(
              child: StreamReactionBubble(
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
                reverse: true,
                flipTail: true,
                tailCirclesSpacing: 4,
              ),
            ),
          ),
        ),
        surfaceSize: const Size(200, 200),
        wrapper: (child) => MaterialAppWrapper(
          theme: themeData,
          home: child,
        ),
      );

      await screenMatchesGolden(tester, 'reaction_bubble_2');
    },
  );
}
