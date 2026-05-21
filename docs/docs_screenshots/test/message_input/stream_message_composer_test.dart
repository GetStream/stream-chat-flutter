import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

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

  docsGoldenTest(
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

  docsGoldenTest(
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

  docsGoldenTest(
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

      final controller = StreamMessageComposerController();

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          componentBuilders: StreamComponentBuilders(
            extensions: streamChatComponentBuilders(
              messageComposerInputTrailing: (context, props) => const SizedBox.shrink(),
              messageComposerTrailing: (context, props) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: context.streamSpacing.xs),
                  StreamButton.icon(
                    icon: Icon(context.streamIcons.send),
                    size: StreamButtonSize.large,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  StreamMessageComposer(messageComposerController: controller),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  docsGoldenTest(
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
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
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

  docsGoldenTest(
    'slow mode active',
    fileName: 'message_composer_slow_mode',
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

      when(channel.getRemainingCooldown).thenReturn(10);

      return _buildMessageInputScaffold(client: client, channel: channel);
    },
  );

  docsGoldenTest(
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

      final controller = StreamMessageComposerController()
        ..quotedMessage = Message(
          id: 'quoted-msg',
          text: 'This is the original message',
          user: ameliaMoore,
        );

      return _buildMessageInputScaffold(
        client: client,
        channel: channel,
        messageInput: StreamMessageComposer(messageComposerController: controller),
      );
    },
  );

  docsGoldenTest(
    'custom composer buttons',
    fileName: 'message_input_custom_buttons',
    constraints: const BoxConstraints.tightFor(width: 375, height: 120),
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

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          componentBuilders: StreamComponentBuilders(
            extensions: streamChatComponentBuilders(
              messageComposerLeading: (context, props) => const SizedBox.shrink(),
              messageComposerInputLeading: (context, props) => StreamButton.icon(
                icon: Icon(context.streamIcons.emoji),
                type: StreamButtonType.ghost,
                style: StreamButtonStyle.secondary,
                size: StreamButtonSize.small,
                onPressed: () {},
              ),
              messageComposerInputTrailing: (context, props) => const SizedBox.shrink(),
              messageComposerTrailing: (context, props) => _CustomComposerTrailingButton(props: props),
            ),
          ),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: Scaffold(
              body: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  StreamMessageComposer(
                    messageComposerController: controller,
                    placeholderBuilder: (context, placeholder) => 'Type a message...',
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

class _CustomComposerTrailingButton extends StatefulWidget {
  const _CustomComposerTrailingButton({required this.props});

  final MessageComposerComponentProps props;

  @override
  State<_CustomComposerTrailingButton> createState() => _CustomComposerTrailingButtonState();
}

class _CustomComposerTrailingButtonState extends State<_CustomComposerTrailingButton> {
  var _isEmptyText = true;

  @override
  void initState() {
    super.initState();
    widget.props.controller.addListener(_updateIsEmptyText);
  }

  void _updateIsEmptyText() {
    final isEmptyText = widget.props.controller.text.trim().isEmpty;
    if (_isEmptyText != isEmptyText) {
      setState(() => _isEmptyText = isEmptyText);
    }
  }

  @override
  void dispose() {
    widget.props.controller.removeListener(_updateIsEmptyText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final button = _isEmptyText
        ? StreamButton.icon(
            icon: Icon(context.streamIcons.voice),
            type: StreamButtonType.outline,
            style: StreamButtonStyle.secondary,
            size: StreamButtonSize.large,
            onPressed: () {},
          )
        : StreamButton.icon(
            icon: Icon(context.streamIcons.send),
            type: StreamButtonType.solid,
            style: StreamButtonStyle.primary,
            size: StreamButtonSize.large,
            onPressed: () {},
          );
    // Mirror the `SizedBox(width: spacing.xs)` that
    // `DefaultStreamMessageComposerLeading` puts AFTER its attachment button —
    // gives the trailing button the same gap from the input pill that the
    // leading attachment button has on the other side.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: context.streamSpacing.xs),
        button,
      ],
    );
  }
}
