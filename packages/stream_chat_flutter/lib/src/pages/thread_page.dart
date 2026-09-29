import 'package:flutter/material.dart';
import '../../stream_chat_flutter.dart';

/// A page that displays a thread of messages for a given parent message.
///
/// Wires up a [StreamThreadHeader], a [StreamMessageListView] scoped to [parent]
/// and a [StreamMessageComposer] that addresses new messages to the thread, laid
/// out floating or regular according to the ambient [StreamSurfaceStyle]. Expects a
/// [StreamChannel] ancestor.
///
/// The composer is omitted when [parent] is deleted.
///
/// ## Customizing this page
///
/// As with [StreamChannelPage], the constructor is small because customization
/// happens through the component factory and the global configuration rather
/// than through parameters — see [StreamChannelPage] for the full rundown and an
/// example. In short:
///
///  * Components (`messageItem`, `messageComposer`, attachments, …) —
///    [streamChatComponentBuilders] on [StreamChat.componentBuilders].
///  * List behavior — [StreamChatConfigurationData.messageListViewConfiguration]
///    on [StreamChat.configData].
///  * Not reachable: [StreamMessageListViewBuilders] list-level slots and
///    [StreamThreadHeader]'s title and actions.
class StreamThreadPage extends StatefulWidget {
  /// Creates a [StreamThreadPage].
  const StreamThreadPage({
    super.key,
    required this.parent,
    this.initialScrollIndex,
    this.initialAlignment,
    this.onViewInChannelTap,
    this.onBackPressed,
  });

  /// The parent message of the thread.
  final Message parent;

  /// Initial scroll index for the thread message list.
  final int? initialScrollIndex;

  /// Initial scroll alignment for the thread message list.
  final double? initialAlignment;

  /// Called when the user taps "View in channel".
  final void Function(Message message)? onViewInChannelTap;

  /// Called when the header's back button is pressed.
  ///
  /// Replaces the default action, which pops the current route. When null the
  /// default is kept.
  final VoidCallback? onBackPressed;

  @override
  State<StreamThreadPage> createState() => _StreamThreadPageState();
}

class _StreamThreadPageState extends State<StreamThreadPage> {
  late final FocusNode _focusNode = FocusNode();
  late final StreamMessageComposerController _messageComposerController = StreamMessageComposerController(
    message: Message(parentId: widget.parent.id),
  );

  @override
  void dispose() {
    _focusNode.dispose();
    _messageComposerController.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageComposerController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
    });
  }

  void _editMessage(Message message) {
    _messageComposerController.editMessage(message);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = StreamThreadHeader(
      parent: widget.parent,
      // Leaving this null keeps the header's default back button, which pops
      // the route.
      onBackPressed: widget.onBackPressed,
    );

    final composer = !widget.parent.isDeleted
        ? StreamMessageComposer(
            focusNode: _focusNode,
            messageComposerController: _messageComposerController,
            enableVoiceRecording: true,
          )
        : null;

    return StreamScaffold(
      appBar: appBar,
      bottom: composer,
      // Resolved from the slots so the body inset matches what the chrome draws.
      // The bottom value is ignored when the composer is null (deleted parent).
      appBarSurfaceStyle: StreamThreadHeader.resolveSurfaceStyle(context),
      bottomSurfaceStyle: StreamMessageComposer.resolveSurfaceStyle(context),
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
    return StreamMessageListView(
      parentMessage: parent,
      initialScrollIndex: initialScrollIndex,
      initialAlignment: initialAlignment,
      onReplyTap: onReply,
      onEditMessageTap: onEditMessageTap,
      onViewInChannelTap: onViewInChannelTap,
      enableSafeArea: true,
    );
  }
}
