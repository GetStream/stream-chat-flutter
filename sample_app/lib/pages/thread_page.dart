import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({
    super.key,
    required this.parent,
    this.initialScrollIndex,
    this.initialAlignment,
    this.onViewInChannelTap,
  });
  final Message parent;
  final int? initialScrollIndex;
  final double? initialAlignment;
  final void Function(Message message)? onViewInChannelTap;

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
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
