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

  void _editMessage(Message message) {
    _messageComposerController.editMessage(message);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = StreamThreadHeader(parent: widget.parent);

    final composer = widget.parent.type != 'deleted'
        ? StreamMessageComposer(
            focusNode: _focusNode,
            messageComposerController: _messageComposerController,
            enableVoiceRecording: true,
          )
        : null;

    return StreamScaffold(
      appBar: appBar,
      bottom: composer,
      body: _ThreadBody(
        parent: widget.parent,
        initialScrollIndex: widget.initialScrollIndex,
        initialAlignment: widget.initialAlignment,
        onReply: _reply,
        onEditMessageTap: _editMessage,
        onViewInChannelTap: widget.onViewInChannelTap,
      ),
    );
  }
}

class _ThreadBody extends StatelessWidget {
  const _ThreadBody({
    required this.parent,
    required this.onReply,
    required this.onEditMessageTap,
    this.initialScrollIndex,
    this.initialAlignment,
    this.onViewInChannelTap,
  });

  final Message parent;
  final void Function(Message) onReply;
  final int? initialScrollIndex;
  final double? initialAlignment;
  final void Function(Message message)? onViewInChannelTap;
  final void Function(Message message)? onEditMessageTap;

  @override
  Widget build(BuildContext context) {
    final insets = StreamScaffoldInsets.of(context);

    return StreamMessageListView(
      parentMessage: parent,
      initialScrollIndex: initialScrollIndex,
      initialAlignment: initialAlignment,
      onReplyTap: onReply,
      onEditMessageTap: onEditMessageTap,
      config: const StreamMessageListViewConfiguration(
        swipeToReply: true,
        showScrollToBottom: false,
        highlightInitialMessage: true,
      ),
      onViewInChannelTap: onViewInChannelTap,
      topPadding: insets.topPadding,
      bottomPadding: insets.bottomPadding,
    );
  }
}
