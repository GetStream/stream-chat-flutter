import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';

final _sender = User(id: 'user-2', name: 'Bob');
final _currentUser = User(id: 'user-1', name: 'Alice');

Widget _buildMessageScaffold({
  required MockClient client,
  required MockChannel channel,
  required Widget child,
}) {
  return MaterialApp(
    theme: docsScreenshotsTheme(),
    debugShowCheckedModeBanner: false,
    home: StreamChat(
      client: client,
      connectivityStream: Stream.value([ConnectivityResult.mobile]),
      child: StreamChannel(
        showLoading: false,
        channel: channel,
        child: Scaffold(body: child),
      ),
    ),
  );
}

void _setupBasicChannel(MockClient client, MockClientState clientState, MockChannel channel, MockChannelState channelState) {
  setupMockChannel(
    client: client,
    clientState: clientState,
    channel: channel,
    channelState: channelState,
    channelName: 'General',
  );
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-1', name: 'Alice'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  goldenTest(
    'message widget actions',
    fileName: 'message_widget_actions',
    constraints: const BoxConstraints.tightFor(width: 375, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);

      final message = Message(
        id: 'msg-1',
        text: 'Hello! This message has actions.',
        user: _sender,
        createdAt: DateTime(2024, 6, 1, 10, 0),
        reactionGroups: {
          'love': ReactionGroup(
            count: 3,
            sumScores: 3,
            firstReactionAt: DateTime(2024, 6, 1, 10, 1),
            lastReactionAt: DateTime(2024, 6, 1, 10, 2),
          ),
        },
      );

      return _buildMessageScaffold(
        client: client,
        channel: channel,
        child: Center(
          child: StreamMessageWidget(message: message),
        ),
      );
    },
  );

  goldenTest(
    'message theming',
    fileName: 'message_theming',
    constraints: const BoxConstraints.tightFor(width: 375, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);

      final message = Message(
        id: 'msg-2',
        text: 'This message uses a custom theme!',
        user: _sender,
        createdAt: DateTime(2024, 6, 1, 10, 0),
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChatTheme(
            data: StreamChatThemeData.light().copyWith(
              ownMessageTheme: StreamMessageThemeData(
                messageBackgroundColor: Colors.purple.shade100,
                messageTextStyle: const TextStyle(color: Colors.purple),
              ),
            ),
            child: StreamChannel(
              showLoading: false,
              channel: channel,
              child: Scaffold(
                body: Center(
                  child: StreamMessageWidget(message: message),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'message reaction theming',
    fileName: 'message_reaction_theming',
    constraints: const BoxConstraints.tightFor(width: 375, height: 200),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);

      final message = Message(
        id: 'msg-3',
        text: 'Check out these reactions!',
        user: _sender,
        createdAt: DateTime(2024, 6, 1, 10, 0),
        reactionGroups: {
          'love': ReactionGroup(
            count: 5,
            sumScores: 5,
            firstReactionAt: DateTime(2024, 6, 1),
            lastReactionAt: DateTime(2024, 6, 1),
          ),
          'haha': ReactionGroup(
            count: 2,
            sumScores: 2,
            firstReactionAt: DateTime(2024, 6, 1),
            lastReactionAt: DateTime(2024, 6, 1),
          ),
        },
      );

      return _buildMessageScaffold(
        client: client,
        channel: channel,
        child: Center(child: StreamMessageWidget(message: message)),
      );
    },
  );

  goldenTest(
    'message with rounded avatar',
    fileName: 'message_rounded_avatar',
    constraints: const BoxConstraints.tightFor(width: 375, height: 120),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);

      final message = Message(
        id: 'msg-4',
        text: 'Message with user avatar shown.',
        user: _sender,
        createdAt: DateTime(2024, 6, 1, 10, 0),
      );

      return _buildMessageScaffold(
        client: client,
        channel: channel,
        child: Center(child: StreamMessageWidget(message: message)),
      );
    },
  );

  goldenTest(
    'message styles',
    fileName: 'message_styles',
    constraints: const BoxConstraints.tightFor(width: 375, height: 300),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      _setupBasicChannel(client, clientState, channel, channelState);

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamMessageWidget(
                    message: Message(
                      id: 'msg-from-other',
                      text: 'This is a message from Bob.',
                      user: _sender,
                      createdAt: DateTime(2024, 6, 1, 10, 0),
                    ),
                  ),
                  StreamMessageWidget(
                    message: Message(
                      id: 'msg-from-me',
                      text: 'And this is my reply!',
                      user: _currentUser,
                      createdAt: DateTime(2024, 6, 1, 10, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
