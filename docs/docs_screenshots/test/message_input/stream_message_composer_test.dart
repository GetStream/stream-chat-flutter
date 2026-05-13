import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';

Widget _buildMessageInputScaffold({
  required MockClient client,
  required MockChannel channel,
  StreamMessageComposer? messageInput,
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
              messageInput ?? StreamMessageComposer(),
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
    fileName: 'stream_message_composer_default',
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
    'message input default',
    fileName: 'message_input',
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
    'message input actions on right',
    fileName: 'message_input_change_position',
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

      final controller = StreamMessageInputController();

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
                  StreamMessageComposer(messageInputController: controller),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'custom send icon via StreamIcons',
    fileName: 'message_input_custom_send_icon',
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

      final streamTextTheme = core.StreamTextTheme().apply(
        color: core.StreamColorScheme.light().systemText,
        fontFamily: 'Roboto',
      );

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          extensions: [
            StreamTheme(
              brightness: Brightness.light,
              textTheme: streamTextTheme,
              icons: const StreamIcons(send: Icons.reply_rounded),
            ),
          ],
        ),
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
                  StreamMessageComposer(),
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

      final controller = StreamMessageInputController()
        ..quotedMessage = Message(
          id: 'quoted-msg',
          text: 'This is the original message',
          user: User(id: 'other-user', name: 'Alice'),
        );

      return _buildMessageInputScaffold(
        client: client,
        channel: channel,
        messageInput: StreamMessageComposer(messageInputController: controller),
      );
    },
  );
}
