import 'package:material_ui/material_ui.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A channel page with optional floating composer support.
///
/// Wires up a [StreamChannelHeader], a [StreamMessageListView] and a
/// [StreamMessageComposer], laid out floating or regular according to the ambient
/// [StreamSurfaceStyle]. Expects a [StreamChannel] ancestor.
///
/// ## Customizing this page
///
/// The constructor is deliberately small — most customization happens through
/// the component factory and the global configuration, both of which reach
/// inside this page because the components resolve them themselves.
///
/// Swap out components with [streamChatComponentBuilders], passed to
/// [StreamChat.componentBuilders]:
///
/// ```dart
/// StreamChat(
///   client: client,
///   componentBuilders: StreamComponentBuilders(
///     extensions: streamChatComponentBuilders(
///       // Applies to the messages this page's list renders.
///       messageItem: (context, props) => DefaultStreamMessageItem(
///         props: props.copyWith(maxWidth: 320),
///       ),
///       // Applies to this page's composer.
///       messageComposer: (context, props) => DefaultStreamMessageComposer(
///         props: props.copyWith(disableAttachments: true),
///       ),
///     ),
///   ),
///   child: child,
/// )
/// ```
///
/// `messageItem`, `messageComposer`, `quotedMessage`, `mentionItem`, the
/// attachment builders, `mediaGallery` and `videoPlayer` all apply here.
///
/// Change list behavior — `swipeToReply`, `highlightInitialMessage`,
/// `autoScrollPolicy` and the rest — through
/// [StreamChatConfigurationData.messageListViewConfiguration] on
/// [StreamChat.configData].
///
/// Not reachable from here: the list-level slots on
/// [StreamMessageListViewBuilders] (`header`, `footer`, `dateDivider`,
/// `floatingDateDivider`, `threadSeparator`, `scrollToBottomButton`, `empty`,
/// `loading`, `error`) and [StreamChannelHeader]'s title, subtitle and actions.
/// Those have no component-factory entry, so customizing them means composing
/// [StreamMessageListView] and [StreamChannelHeader] directly instead of using
/// this page.
///
/// See also:
///
///  * [StreamThreadPage], the equivalent page for a single thread.
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

  /// Called when the header's back button is pressed.
  ///
  /// Replaces the default action, which pops the current route. When null the
  /// default is kept.
  final VoidCallback? onBackPressed;

  /// Called when the default channel-avatar in the trailing slot is pressed.
  final void Function(BuildContext context, Channel channel)? onChannelAvatarPressed;

  @override
  State<StreamChannelPage> createState() => _StreamChannelPageState();
}

class _StreamChannelPageState extends State<StreamChannelPage> {
  late final FocusNode _focusNode = FocusNode();
  late final StreamMessageComposerController _messageComposerController = StreamMessageComposerController();

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
    final appBar = StreamChannelHeader(
      // Leaving this null keeps the header's default back button, which pops
      // the route.
      onBackPressed: widget.onBackPressed,
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
      appBar: appBar,
      bottom: composer,
      // Resolved from the slots so the body inset matches what the chrome draws.
      appBarSurfaceStyle: StreamChannelHeader.resolveSurfaceStyle(context),
      bottomSurfaceStyle: StreamMessageComposer.resolveSurfaceStyle(context),
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

// The body of a channel page.
//
// Positions the typing indicator just above the composer (floating or docked)
// via a bottom SafeArea over the floating-bar insets in MediaQuery.padding
// (injected by StreamScaffold). StreamMessageListView reads the same insets
// directly to pad its scroll content.
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
          enableSafeArea: true,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          // A bottom SafeArea lifts the indicator above the composer / bottom
          // bar — the scaffold injects its extent into MediaQuery.padding.bottom.
          child: SafeArea(top: false, child: typingIndicator),
        ),
      ],
    );
  }
}
