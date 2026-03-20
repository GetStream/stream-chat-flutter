import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  goldenTest(
    'poll creator widget',
    fileName: 'poll_creator',
    constraints: const BoxConstraints.tightFor(width: 375, height: 600),
    builder: () {
      final client = MockClient();


      final controller = StreamPollController(
        poll: Poll(
          id: 'poll-1',
          name: 'What is your favorite programming language?',
          options: [
            const PollOption(id: 'opt-1', text: 'Dart'),
            const PollOption(id: 'opt-2', text: 'Swift'),
            const PollOption(id: 'opt-3', text: 'Kotlin'),
          ],
        ),
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: StreamPollCreatorWidget(
              controller: controller,
              shrinkWrap: true,
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'poll interactor widget',
    fileName: 'poll_interactor',
    constraints: const BoxConstraints.tightFor(width: 375, height: 400),
    builder: () {
      final client = MockClient();


      final currentUser = User(id: 'user-1', name: 'Alice');

      final poll = Poll(
        id: 'poll-2',
        name: 'Which feature would you like to see next?',
        options: [
          const PollOption(id: 'opt-a', text: 'Offline mode'),
          const PollOption(id: 'opt-b', text: 'Message scheduling'),
          const PollOption(id: 'opt-c', text: 'Voice messages'),
          const PollOption(id: 'opt-d', text: 'Reactions 2.0'),
        ],
        voteCountsByOption: {
          'opt-a': 8,
          'opt-b': 5,
          'opt-c': 12,
          'opt-d': 3,
        },
        voteCount: 28,
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: SingleChildScrollView(
              child: StreamPollInteractor(
                poll: poll,
                currentUser: currentUser,
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
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
          options: [
            const PollOption(id: 'p1', text: 'Pizza 🍕'),
            const PollOption(id: 'p2', text: 'Tacos 🌮'),
            const PollOption(id: 'p3', text: 'Both!'),
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
