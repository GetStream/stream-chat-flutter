import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  docsGoldenTest(
    'mention autocomplete trigger',
    fileName: 'autocomplete_trigger_mention',
    constraints: const BoxConstraints.tightFor(width: 375, height: 290),
    pumpBeforeTest: (tester) async {
      await tester.pump(); // let FutureBuilder resolve and show user list
      await precacheImages(tester); // now precache the avatar images in the tree
    },
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      final members = [
        noahSmith,
        liamJohnson,
        miaThompson,
        ethanWilson,
      ].map((user) => Member(userId: user.id, user: user)).toList();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        members: members,
      );

      when(() => channelState.watchers).thenReturn([]);

      final messageComposerController = StreamMessageComposerController()..message = Message(text: 'Hello @');

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamMentionAutocompleteOptions(
                  query: '',
                  channel: channel,
                ),
                StreamMessageComposer(messageComposerController: messageComposerController),
              ],
            ),
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'commands autocomplete trigger',
    fileName: 'autocomplete_trigger_commands',
    constraints: const BoxConstraints.tightFor(width: 375, height: 340),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
      );

      when(() => channel.config).thenReturn(
        ChannelConfig(
          commands: [
            Command(
              name: 'giphy',
              description: 'Post a random gif to the channel',
              args: '[text]',
            ),
            Command(
              name: 'ban',
              description: 'Ban a user',
              args: '@username [text]',
            ),
            Command(
              name: 'flag',
              description: 'Flag a message',
              args: '[messageId]',
            ),
            Command(
              name: 'mute',
              description: 'Mute a user',
              args: '@username',
            ),
          ],
        ),
      );

      final messageComposerController = StreamMessageComposerController()..message = Message(text: '/');

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StreamCommandAutocompleteOptions(
                  query: '',
                  channel: channel,
                ),
                StreamMessageComposer(messageComposerController: messageComposerController),
              ],
            ),
          ),
        ),
      );
    },
  );
}
