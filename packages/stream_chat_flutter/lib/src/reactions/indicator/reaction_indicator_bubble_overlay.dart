import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/reactions/indicator/reaction_indicator.dart';
import 'package:stream_chat_flutter/src/reactions/reaction_bubble_overlay.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class ReactionIndicatorBubbleOverlay extends StatelessWidget {
  const ReactionIndicatorBubbleOverlay({
    super.key,
    this.onTap,
    required this.message,
    required this.child,
    this.visible = true,
    this.reverse = false,
    this.anchorOffset = Offset.zero,
    this.childSizeDelta = Offset.zero,
  });

  final bool visible;
  final bool reverse;
  final Widget child;

  /// Message to attach the reaction to.
  final Message message;

  /// Callback triggered when the reaction indicator is tapped.
  final VoidCallback? onTap;

  final Offset anchorOffset;

  final Offset childSizeDelta;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final messageTheme = theme.getMessageTheme(reverse: reverse);

    return ReactionBubbleOverlay(
      visible: visible,
      childSizeDelta: childSizeDelta,
      config: ReactionBubbleConfig(
        fillColor: messageTheme.reactionsBackgroundColor,
        borderColor: messageTheme.reactionsBorderColor,
        maskColor: messageTheme.reactionsMaskColor,
      ),
      anchor: ReactionBubbleAnchor(
        offset: anchorOffset,
        follower: AlignmentDirectional.bottomCenter,
        target: AlignmentDirectional(reverse ? -1 : 1, -1),
      ),
      reaction: StreamReactionIndicator(
        onTap: onTap,
        message: message,
        backgroundColor: messageTheme.reactionsBackgroundColor,
      ),
      child: child,
    );
  }
}
