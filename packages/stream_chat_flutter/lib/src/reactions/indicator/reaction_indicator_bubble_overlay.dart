import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/reactions/indicator/reaction_indicator.dart';
import 'package:stream_chat_flutter/src/reactions/reaction_bubble_overlay.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template reactionIndicatorBubbleOverlay}
/// A widget that displays a reaction indicator bubble overlay attached to a
/// [child] widget. Typically used to show the reactions for a [Message].
///
/// It positions the reaction indicator relative to the provided [child] widget,
/// using the given [anchorOffset] and [childSizeDelta] for fine-tuned placement
/// {@endtemplate}
class ReactionIndicatorBubbleOverlay extends StatelessWidget {
  /// {@macro reactionIndicatorBubbleOverlay}
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

  /// Whether the overlay should be visible.
  final bool visible;

  /// Whether to reverse the alignment of the overlay.
  final bool reverse;

  /// The widget to which the overlay is anchored.
  final Widget child;

  /// The message to display reactions for.
  final Message message;

  /// Callback triggered when the reaction indicator is tapped.
  final VoidCallback? onTap;

  /// The offset to apply to the anchor position.
  final Offset anchorOffset;

  /// The additional size delta to apply to the child widget for positioning.
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
