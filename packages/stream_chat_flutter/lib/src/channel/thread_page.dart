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

  @override
  Widget build(BuildContext context) {
    final appBar = StreamThreadHeader(parent: widget.parent);
    final isFloating = StreamTheme.of(context).appStyle.appBarBehavior == .floating;

    return Scaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: appBar,
      extendBodyBehindAppBar: isFloating,
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
              topPadding: isFloating ? appBar.preferredSize.height + MediaQuery.of(context).padding.top : 0.0,
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
