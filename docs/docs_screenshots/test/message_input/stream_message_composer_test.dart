import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/fakes.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

Widget _buildMessageInputScaffold({
  required MockClient client,
  required MockChannel channel,
  StreamMessageComposer? messageInput,
}) {
  return StreamChat(
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

      // Seed the controller with text so the trailing slot shows the send
      // button instead of the voice-record mic (the default when empty).
      final controller = StreamMessageComposerController()..text = 'Hello!';
      addTearDown(controller.dispose);

      return _buildMessageInputScaffold(
        client: client,
        channel: channel,
        messageInput: StreamMessageComposer(messageComposerController: controller),
      );
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

      // Seed the controller with text so the trailing slot shows the send
      // button instead of the voice-record mic (the default when empty).
      final controller = StreamMessageComposerController()..text = 'Hello!';
      addTearDown(controller.dispose);

      return _buildMessageInputScaffold(
        client: client,
        channel: channel,
        messageInput: StreamMessageComposer(messageComposerController: controller),
      );
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
      addTearDown(controller.dispose);

      return StreamChat(
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

      // Seed the controller with text so the trailing slot shows the send
      // button (with the custom icon) instead of the default voice-record mic.
      final controller = StreamMessageComposerController()..text = 'Hello!';
      addTearDown(controller.dispose);

      return Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final streamTheme = theme.extension<StreamTheme>()!;
          return Theme(
            data: theme.copyWith(
              extensions: [
                ...theme.extensions.values.where((e) => e is! StreamTheme),
                streamTheme.copyWith(
                  icons: const StreamIcons(send: Icons.reply_rounded),
                ),
              ],
            ),
            child: StreamChat(
              client: client,
              connectivityStream: Stream.value([ConnectivityResult.mobile]),
              child: StreamChannel(
                showLoading: false,
                channel: channel,
                child: Scaffold(
                  body: Column(
                    children: [
                      Expanded(child: Container()),
                      StreamMessageComposer(messageComposerController: controller),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
      when(() => channel.getRemainingCooldown(lastMessageAt: any(named: 'lastMessageAt'))).thenReturn(10);

      return _buildMessageInputScaffold(client: client, channel: channel);
    },
  );

  docsGoldenTest(
    'message input with quoted message',
    fileName: 'message_input_quoted_message',
    constraints: const BoxConstraints.tightFor(width: 375, height: 180),
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
      addTearDown(controller.dispose);

      return _buildMessageInputScaffold(
        client: client,
        channel: channel,
        messageInput: StreamMessageComposer(messageComposerController: controller),
      );
    },
  );

  docsGoldenTest(
    'custom input header banner',
    fileName: 'message_composer_input_header',
    constraints: const BoxConstraints.tightFor(width: 375, height: 140),
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
      addTearDown(controller.dispose);

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        componentBuilders: StreamComponentBuilders(
          extensions: streamChatComponentBuilders(
            messageComposerInputHeader: (context, props) {
              // Custom header: replace the default with a moderation banner.
              // Add the quoted-message/attachment preview logic here if needed.
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: const Color(0xFFFFF9C4),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFB45309)),
                    SizedBox(width: 6),
                    Text(
                      'This channel is moderated',
                      style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                    ),
                  ],
                ),
              );
            },
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
      );
    },
  );

  docsGoldenTest(
    'custom composer buttons',
    fileName: 'message_input_custom_buttons',
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
      addTearDown(controller.dispose);

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        componentBuilders: StreamComponentBuilders(
          extensions: streamChatComponentBuilders(
            messageComposerLeading: (context, props) => const SizedBox.shrink(),
            messageComposerInputTrailing: (context, props) => StreamButton.icon(
              icon: Icon(context.streamIcons.attachment),
              type: StreamButtonType.ghost,
              style: StreamButtonStyle.secondary,
              size: StreamButtonSize.small,
              onPressed: () {},
            ),
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
                  placeholderBuilder: (context, placeholder) => 'Message',
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Outer trailing button that toggles between a microphone (empty text) and
/// a send icon (text present), styled with the SDK's primary solid colour.
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
    final icon = _isEmptyText ? context.streamIcons.voice : context.streamIcons.send;
    // Mirror the `SizedBox(width: spacing.xs)` that
    // `DefaultStreamMessageComposerLeading` puts AFTER its attachment button —
    // gives the trailing button the same gap from the input pill that the
    // leading attachment button has on the other side.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: context.streamSpacing.xs),
        StreamButton.icon(
          icon: Icon(icon),
          size: StreamButtonSize.large,
          onPressed: () {},
        ),
      ],
    );
  }
}
