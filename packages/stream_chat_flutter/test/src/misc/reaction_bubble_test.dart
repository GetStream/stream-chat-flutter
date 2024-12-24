import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  goldenTest(
    'it should show a like - light theme',
    fileName: 'reaction_bubble_like_light',
    constraints: const BoxConstraints.tightFor(width: 100, height: 100),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData.light(
        useMaterial3: false,
      );

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      final theme = StreamChatThemeData.fromTheme(themeData);
      return MaterialAppWrapper(
        theme: themeData,
        home: StreamChat(
          client: client,
          streamChatThemeData: theme,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
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
      );
    },
  );

  goldenTest(
    'it should show a like - dark theme',
    fileName: 'reaction_bubble_like_dark',
    constraints: const BoxConstraints.tightFor(width: 100, height: 100),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData.dark();
      final theme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      return MaterialAppWrapper(
        theme: themeData,
        home: StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.fromTheme(themeData),
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
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
      );
    },
  );

  goldenTest(
    'it should show three reactions - light theme',
    fileName: 'reaction_bubble_3_light',
    constraints: const BoxConstraints.tightFor(width: 140, height: 140),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData.light();
      final theme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      return MaterialAppWrapper(
        theme: themeData,
        home: StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.fromTheme(themeData),
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: Center(
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
                backgroundColor:
                    theme.ownMessageTheme.reactionsBackgroundColor!,
                maskColor: theme.ownMessageTheme.reactionsMaskColor!,
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'it should show three reactions - dark theme',
    fileName: 'reaction_bubble_3_dark',
    constraints: const BoxConstraints.tightFor(width: 140, height: 140),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData.dark();
      final theme = StreamChatThemeData.fromTheme(themeData);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      return MaterialAppWrapper(
        theme: themeData,
        home: StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.fromTheme(themeData),
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: Center(
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
                backgroundColor:
                    theme.ownMessageTheme.reactionsBackgroundColor!,
                maskColor: theme.ownMessageTheme.reactionsMaskColor!,
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'it should show two reactions with customized ui',
    fileName: 'reaction_bubble_2',
    constraints: const BoxConstraints.tightFor(width: 200, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final themeData = ThemeData(
        useMaterial3: false,
      );

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      return MaterialAppWrapper(
        theme: themeData,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
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
      );
    },
  );
}
