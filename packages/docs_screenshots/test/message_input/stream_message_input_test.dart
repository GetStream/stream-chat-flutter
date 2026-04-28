import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';

Widget _buildMessageInputScaffold({
  required MockClient client,
  required MockChannel channel,
  Widget? messageComposer,
}) {
  return MaterialApp(
    theme: docsScreenshotsTheme(),
    debugShowCheckedModeBanner: false,
    home: StreamChat(
      client: client,
      streamChatThemeData: docsStreamChatThemeData(),
      connectivityStream: Stream.value([ConnectivityResult.mobile]),
      child: StreamChannel(
        showLoading: false,
        channel: channel,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(child: Container()),
              messageComposer ?? StreamChatMessageComposer(),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  goldenTest(
    'default state',
    fileName: 'stream_message_input_default',
    constraints: const BoxConstraints.tightFor(width: 375, height: 100),
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

      return _buildMessageInputScaffold(client: client, channel: channel);
    },
  );

  goldenTest(
    'message input with text',
    fileName: 'message_input_with_text',
    constraints: const BoxConstraints.tightFor(width: 375, height: 100),
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

      final controller = StreamMessageComposerController();
      controller.inputController.textFieldController.text = 'Hello world!';

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          streamChatThemeData: docsStreamChatThemeData(),
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          componentBuilders: StreamComponentBuilders(
            extensions: streamChatComponentBuilders(
              messageComposerInputTrailing: (context, props) => const SizedBox.shrink(),
              messageComposerTrailing: (context, props) => DefaultStreamMessageComposerInputTrailing(props: props),
            ),
          ),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  StreamChatMessageComposer(controller: controller),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'message input with quoted message',
    fileName: 'message_input_quoted_message',
    constraints: const BoxConstraints.tightFor(width: 375, height: 160),
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

      final controller = StreamMessageComposerController(
        message: Message(
          quotedMessage: Message(
            id: 'quoted-msg',
            text: 'This is the original message',
            user: User(id: 'other-user', name: 'Alice'),
          ),
        ),
      );

      return _buildMessageInputScaffold(
        client: client,
        channel: channel,
        messageComposer: StreamChatMessageComposer(controller: controller),
      );
    },
  );
}
