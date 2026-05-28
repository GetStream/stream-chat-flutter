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
  late StreamMessageComposerController _messageComposerController;

  @override
  void initState() {
    super.initState();
    _messageComposerController = StreamMessageComposerController(
      message: Message(parentId: widget.parent.id),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _messageComposerController.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageComposerController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: StreamThreadHeader(parent: widget.parent),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: widget.parent,
              initialScrollIndex: widget.initialScrollIndex,
              initialAlignment: widget.initialAlignment,
              onReplyTap: _reply,
              config: const StreamMessageListViewConfiguration(
                swipeToReply: true,
                showScrollToBottom: false,
                highlightInitialMessage: true,
              ),
              onViewInChannelTap: widget.onViewInChannelTap,
            ),
          ),
          if (widget.parent.type != 'deleted')
            StreamMessageComposer(
              focusNode: _focusNode,
              messageComposerController: _messageComposerController,
              enableVoiceRecording: true,
            ),
        ],
      ),
    );
  }
}
