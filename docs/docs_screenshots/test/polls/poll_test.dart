import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

final _sender = noahSmith;

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'poll creator widget',
    fileName: 'poll_creator',
    constraints: const BoxConstraints.tightFor(width: 375, height: 650),
    builder: () {
      final client = MockClient();

      final controller = StreamPollController(
        poll: Poll(
          id: 'poll-1',
          name: 'What is your favorite programming language?',
          options: const [
            PollOption(id: 'opt-1', text: 'Dart'),
            PollOption(id: 'opt-2', text: 'Swift'),
            PollOption(id: 'opt-3', text: 'Kotlin'),
          ],
        ),
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Builder(
            builder: (context) {
              final icons = context.streamIcons;
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(icons.xmark),
                    onPressed: null,
                  ),
                  title: const Text('Create Poll'),
                  actions: [
                    IconButton(
                      icon: Icon(icons.send),
                      onPressed: null,
                    ),
                  ],
                ),
                body: StreamPollCreatorWidget(
                  controller: controller,
                  shrinkWrap: true,
                ),
              );
            },
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'poll interactor widget',
    fileName: 'poll_interactor',
    constraints: const BoxConstraints.tightFor(width: 375, height: 500),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        channelName: 'General',
      );

      final poll = Poll(
        id: 'poll-2',
        name: 'Which feature would you like to see next?',
        options: const [
          PollOption(id: 'opt-a', text: 'Offline mode'),
          PollOption(id: 'opt-b', text: 'Message scheduling'),
          PollOption(id: 'opt-c', text: 'Voice messages'),
          PollOption(id: 'opt-d', text: 'Reactions 2.0'),
        ],
        voteCountsByOption: const {
          'opt-a': 8,
          'opt-b': 5,
          'opt-c': 12,
          'opt-d': 3,
        },
        voteCount: 28,
      );

      final pollMessage = Message(
        id: 'poll-msg',
        user: _sender,
        poll: poll,
        createdAt: DateTime(2024, 6, 1, 10, 0),
      );

      return _buildMessageScaffold(
        client: client,
        channel: channel,
        child: Center(
          child: StreamMessageItem(message: pollMessage),
        ),
      );
    },
  );

  docsGoldenTest(
    'polls composer attachment picker',
    fileName: 'polls_composer',
    constraints: const BoxConstraints.tightFor(width: 375, height: 500),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        channelName: 'General',
      );

      final pollController = StreamPollController(
        poll: Poll(
          id: 'poll-3',
          name: 'Pizza or Tacos for the team lunch?',
          options: const [
            PollOption(id: 'p1', text: 'Pizza'),
            PollOption(id: 'p2', text: 'Tacos'),
            PollOption(id: 'p3', text: 'Both!'),
          ],
        ),
      );

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
              body: StreamPollCreatorWidget(
                controller: pollController,
                shrinkWrap: true,
              ),
            ),
          ),
        ),
      );
    },
  );
}
