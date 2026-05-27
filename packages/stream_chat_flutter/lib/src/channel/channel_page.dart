// ignore_for_file: deprecated_member_use, avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/channel/thread_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A channel page with optional floating composer support.
class StreamChannelPage extends StatefulWidget {
  /// Creates a [StreamChannelPage].
  const StreamChannelPage({
    super.key,
    this.initialScrollIndex,
    this.initialAlignment,
    this.highlightInitialMessage = false,
    this.onBackPressed,
    this.onChannelAvatarPressed,
    this.isFloating = true,
  });

  /// Initial scroll index for the message list.
  final int? initialScrollIndex;

  /// Initial scroll alignment for the message list.
  final double? initialAlignment;

  /// Whether to highlight the initial message.
  final bool highlightInitialMessage;

  /// Callback for when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Called when the default channel-avatar trailing is pressed.
  final void Function(Channel channel)? onChannelAvatarPressed;

  /// Whether the composer floats over the message list.
  ///
  /// When true the composer is overlaid at the bottom and the message list
  /// scrolls underneath it. Layout is done in a single pass so the list
  /// inset and the composer height are always in sync.
  final bool isFloating;

  @override
  State<StreamChannelPage> createState() => _StreamChannelPageState();
}

class _StreamChannelPageState extends State<StreamChannelPage> {
  FocusNode? _focusNode;
  final _messageComposerController = StreamMessageComposerController();

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageComposerController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  void _editMessage(Message message) {
    _messageComposerController.editMessage(message);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final typingIndicator = StreamTypingIndicator(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      style: context.streamTextTheme.captionDefault.copyWith(
        color: context.streamColorScheme.textSecondary,
      ),
    );

    final composer = StreamMessageComposer(
      focusNode: _focusNode,
      messageComposerController: _messageComposerController,
      onQuotedMessageCleared: _messageComposerController.clearQuotedMessage,
      enableVoiceRecording: true,
      isFloating: widget.isFloating,
    );

    if (widget.isFloating) {
      return Scaffold(
        backgroundColor: context.streamColorScheme.backgroundApp,
        appBar: StreamChannelHeader(
          onChannelAvatarPressed: widget.onChannelAvatarPressed,
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              color: context.streamColorScheme.backgroundApp.withOpacity(.9),
              child: typingIndicator,
            ),
            composer,
          ],
        ),
        body: Builder(
          builder: (context) {
            final insets = MediaQuery.of(context).padding;
            return StreamMessageListView(
              initialScrollIndex: widget.initialScrollIndex,
              initialAlignment: widget.initialAlignment,
              config: StreamMessageListViewConfiguration(
                highlightInitialMessage: widget.highlightInitialMessage,
                swipeToReply: true,
              ),
              onEditMessageTap: _editMessage,
              onReplyTap: _reply,
              threadBuilder: (_, parentMessage) {
                return StreamThreadPage(parent: parentMessage!);
              },
              topPadding: insets.top,
              bottomPadding: insets.bottom,
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: StreamChannelHeader(
        onChannelAvatarPressed: widget.onChannelAvatarPressed,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                StreamMessageListView(
                  initialScrollIndex: widget.initialScrollIndex,
                  initialAlignment: widget.initialAlignment,
                  config: StreamMessageListViewConfiguration(
                    highlightInitialMessage: widget.highlightInitialMessage,
                    swipeToReply: true,
                  ),
                  onEditMessageTap: _editMessage,
                  onReplyTap: _reply,
                  threadBuilder: (_, parentMessage) {
                    return StreamThreadPage(parent: parentMessage!);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: context.streamColorScheme.backgroundApp.withOpacity(.9),
                    child: typingIndicator,
                  ),
                ),
              ],
            ),
          ),
          composer,
        ],
      ),
    );
  }
}
