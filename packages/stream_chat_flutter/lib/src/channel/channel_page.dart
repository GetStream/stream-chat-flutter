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
    this.onHeaderImageTap,
    this.isFloating = false,
  });

  /// Initial scroll index for the message list.
  final int? initialScrollIndex;

  /// Initial scroll alignment for the message list.
  final double? initialAlignment;

  /// Whether to highlight the initial message.
  final bool highlightInitialMessage;

  /// Callback for when the back button is pressed.
  final VoidCallback? onBackPressed;

  /// Callback for when the header image is tapped.
  final VoidCallback? onHeaderImageTap;

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
  final _messageInputController = StreamMessageInputController();

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
    _messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  void _editMessage(Message message) {
    _messageInputController.editMessage(message);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    final appBar = StreamChannelHeader(
      showTypingIndicator: false,
      onBackPressed: widget.onBackPressed,
      onImageTap: widget.onHeaderImageTap,
    );

    final typingIndicator = StreamTypingIndicator(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      style: textTheme.footnote.copyWith(
        color: colorTheme.textLowEmphasis,
      ),
    );

    final composer = StreamMessageComposer(
      focusNode: _focusNode,
      messageInputController: _messageInputController,
      onQuotedMessageCleared: _messageInputController.clearQuotedMessage,
      enableVoiceRecording: true,
      isFloating: widget.isFloating,
    );

    if (widget.isFloating) {
      return Scaffold(
        backgroundColor: colorTheme.appBg,
        appBar: appBar,
        extendBody: true,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              color: colorTheme.appBg.withOpacity(.9),
              child: typingIndicator,
            ),
            composer,
          ],
        ),
        body: Builder(
          builder: (context) {
            final bottomInset = MediaQuery.of(context).padding.bottom;
            return StreamMessageListView(
              initialScrollIndex: widget.initialScrollIndex,
              initialAlignment: widget.initialAlignment,
              highlightInitialMessage: widget.highlightInitialMessage,
              onEditMessageTap: _editMessage,
              onReplyTap: _reply,
              swipeToReply: true,
              threadBuilder: (_, parentMessage) {
                return StreamThreadPage(parent: parentMessage!);
              },
              bottomPadding: bottomInset,
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorTheme.appBg,
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                StreamMessageListView(
                  initialScrollIndex: widget.initialScrollIndex,
                  initialAlignment: widget.initialAlignment,
                  highlightInitialMessage: widget.highlightInitialMessage,
                  onEditMessageTap: _editMessage,
                  onReplyTap: _reply,
                  swipeToReply: true,
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
                    color: colorTheme.appBg.withOpacity(.9),
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
