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
        body: _FloatingChannelBody(
          composer: composer,
          typingIndicator: Container(
            alignment: Alignment.centerLeft,
            color: colorTheme.appBg.withOpacity(.9),
            child: typingIndicator,
          ),
          messageListBuilder: (bottomWidgetsHeight) => StreamMessageListView(
            initialScrollIndex: widget.initialScrollIndex,
            initialAlignment: widget.initialAlignment,
            highlightInitialMessage: widget.highlightInitialMessage,
            onEditMessageTap: _editMessage,
            onReplyTap: _reply,
            swipeToReply: true,
            threadBuilder: (_, parentMessage) {
              return StreamThreadPage(parent: parentMessage!);
            },
            bottomPadding: bottomWidgetsHeight,
          ),
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

// ---------------------------------------------------------------------------
// Floating layout helpers
// ---------------------------------------------------------------------------

/// Layout slot identifiers for [_FloatingChannelBodyDelegate].
enum _Slot { body, typing, composer }

/// A custom [BoxConstraints] subclass that carries the composer height so that
/// a [LayoutBuilder] inside the body slot can read it without a separate
/// callback or [setState].
///
/// The [==] / [hashCode] overrides are intentional: they make the framework
/// re-run [RenderObject.performLayout] on the body child even when the outer
/// size constraints have not changed but only [composerHeight] has.
class _BodyBoxConstraints extends BoxConstraints {
  const _BodyBoxConstraints({
    super.maxWidth,
    super.maxHeight,
    required this.composerHeight,
  }) : assert(composerHeight >= 0, 'composerHeight must be non-negative');

  /// Height of the floating composer, used as the list's bottom inset.
  final double composerHeight;

  @override
  bool operator ==(Object other) {
    if (super != other) return false;
    return other is _BodyBoxConstraints && other.composerHeight == composerHeight;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, composerHeight);
}

/// [MultiChildLayoutDelegate] that measures the composer first, then lays out
/// the typing indicator and body in the same layout pass — no post-frame
/// callback required.
class _FloatingChannelBodyDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    // 1. Measure + position the composer at the bottom.
    final composerSize = layoutChild(_Slot.composer, BoxConstraints.loose(size));
    positionChild(_Slot.composer, Offset(0, size.height - composerSize.height));

    // 2. Measure + position the typing indicator just above the composer.
    final typingSize = layoutChild(_Slot.typing, BoxConstraints(maxWidth: size.width));
    positionChild(_Slot.typing, Offset(0, size.height - composerSize.height - typingSize.height));

    // 3. Lay out the body with the composer height embedded in the constraints
    //    so the LayoutBuilder inside can read it synchronously.
    layoutChild(
      _Slot.body,
      _BodyBoxConstraints(
        maxWidth: size.width,
        maxHeight: size.height,
        composerHeight: composerSize.height,
      ),
    );
    positionChild(_Slot.body, Offset.zero);
  }

  @override
  bool shouldRelayout(_FloatingChannelBodyDelegate oldDelegate) => false;
}

/// Stateless widget that wires the floating layout together.
class _FloatingChannelBody extends StatelessWidget {
  const _FloatingChannelBody({
    required this.composer,
    required this.typingIndicator,
    required this.messageListBuilder,
  });

  final Widget composer;
  final Widget typingIndicator;

  /// Called with the current composer height so the list can set its inset.
  final Widget Function(double bottomWidgetsHeight) messageListBuilder;

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _FloatingChannelBodyDelegate(),
      children: [
        // Body slot: a LayoutBuilder that reads the custom constraints.
        LayoutId(
          id: _Slot.body,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints is _BodyBoxConstraints ? constraints.composerHeight : 0.0;
              return messageListBuilder(height);
            },
          ),
        ),
        LayoutId(id: _Slot.typing, child: typingIndicator),
        LayoutId(id: _Slot.composer, child: composer),
      ],
    );
  }
}
