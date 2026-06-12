import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A channel page with optional floating composer support.
class StreamChannelPage extends StatefulWidget {
  /// Creates a [StreamChannelPage].
  const StreamChannelPage({
    super.key,
    this.initialScrollIndex,
    this.initialAlignment,
    this.onBackPressed,
    this.onChannelAvatarPressed,
  });

  /// Initial scroll index for the message list.
  final int? initialScrollIndex;

  /// Initial scroll alignment for the message list.
  final double? initialAlignment;

  /// Callback for when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Called when the default channel-avatar trailing is pressed.
  final void Function(BuildContext context, Channel channel)? onChannelAvatarPressed;

  @override
  State<StreamChannelPage> createState() => _StreamChannelPageState();
}

class _StreamChannelPageState extends State<StreamChannelPage> {
  late final FocusNode _focusNode;
  final _messageComposerController = StreamMessageComposerController();

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageComposerController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  void _editMessage(Message message) {
    _messageComposerController.editMessage(message);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = StreamChannelHeader(
      onChannelAvatarPressed: (channel) => widget.onChannelAvatarPressed?.call(context, channel),
    );

    final composer = StreamMessageComposer(
      focusNode: _focusNode,
      messageComposerController: _messageComposerController,
      onQuotedMessageCleared: _messageComposerController.clearQuotedMessage,
      enableVoiceRecording: true,
    );

    final typingIndicator = StreamTypingIndicator(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      style: context.streamTextTheme.captionDefault.copyWith(
        color: context.streamColorScheme.textSecondary,
      ),
    );

    return StreamScaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: appBar,
      bottom: composer,
      body: _ChannelPageBody(
        initialScrollIndex: widget.initialScrollIndex,
        initialAlignment: widget.initialAlignment,
        onReply: _reply,
        onEditMessage: _editMessage,
        typingIndicator: typingIndicator,
      ),
    );
  }
}

/// The body of [StreamChannelPage].
///
/// Reads [StreamScaffoldInsets] to provide correct [topPadding] and
/// [bottomPadding] to [StreamMessageListView], and positions the typing
/// indicator just above the composer (floating or docked) using the same
/// inset values.
class _ChannelPageBody extends StatelessWidget {
  const _ChannelPageBody({
    required this.typingIndicator,
    required this.onReply,
    required this.onEditMessage,
    this.initialScrollIndex,
    this.initialAlignment,
  });

  final Widget typingIndicator;
  final void Function(Message) onReply;
  final void Function(Message) onEditMessage;
  final int? initialScrollIndex;
  final double? initialAlignment;

  @override
  Widget build(BuildContext context) {
    final insets = StreamScaffoldInsets.of(context);

    return Stack(
      children: [
        StreamMessageListView(
          initialScrollIndex: initialScrollIndex,
          initialAlignment: initialAlignment,
          onEditMessageTap: onEditMessage,
          onReplyTap: onReply,
          threadBuilder: (_, parentMessage) {
            return StreamThreadPage(parent: parentMessage!);
          },
          topPadding: insets.topPadding,
          bottomPadding: insets.bottomPadding,
        ),
        Positioned(
          bottom: insets.bottomPadding,
          left: 0,
          right: 0,
          child: typingIndicator,
        ),
      ],
    );
  }
}
