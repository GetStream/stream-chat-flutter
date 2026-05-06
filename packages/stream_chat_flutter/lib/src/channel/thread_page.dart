import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A page that displays a thread of messages for a given parent message.
class StreamThreadPage extends StatefulWidget {
  /// Creates a [StreamThreadPage].
  const StreamThreadPage({
    super.key,
    required this.parent,
    this.initialScrollIndex,
    this.initialAlignment,
    this.onViewInChannelTap,
  });

  /// The parent message of the thread.
  final Message parent;

  /// Initial scroll index for the thread message list.
  final int? initialScrollIndex;

  /// Initial scroll alignment for the thread message list.
  final double? initialAlignment;

  /// Called when the user taps "View in channel".
  final void Function(Message message)? onViewInChannelTap;

  @override
  State<StreamThreadPage> createState() => _StreamThreadPageState();
}

class _StreamThreadPageState extends State<StreamThreadPage> {
  final FocusNode _focusNode = FocusNode();
  late StreamMessageInputController _messageInputController;

  @override
  void initState() {
    super.initState();
    _messageInputController = StreamMessageInputController(
      message: Message(parentId: widget.parent.id),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: StreamThreadHeader(parent: widget.parent),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: widget.parent,
              initialScrollIndex: widget.initialScrollIndex,
              initialAlignment: widget.initialAlignment,
              onReplyTap: _reply,
              swipeToReply: true,
              showScrollToBottom: false,
              highlightInitialMessage: true,
              onViewInChannelTap: widget.onViewInChannelTap,
            ),
          ),
          if (widget.parent.type != 'deleted')
            StreamMessageComposer(
              focusNode: _focusNode,
              messageInputController: _messageInputController,
              enableVoiceRecording: true,
            ),
        ],
      ),
    );
  }
}
