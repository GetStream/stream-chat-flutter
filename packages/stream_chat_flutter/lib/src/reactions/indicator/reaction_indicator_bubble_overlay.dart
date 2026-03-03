import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/reactions/indicator/reaction_indicator.dart';
import 'package:stream_chat_flutter/src/reactions/reaction_bubble_overlay.dart';
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
    this.reactionIndicatorBuilder = StreamReactionIndicator.builder,
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

  /// Builder for the reaction indicator widget.
  final ReactionIndicatorBuilder reactionIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    return ReactionBubbleOverlay(
      visible: visible,
      anchor: ReactionBubbleAnchor(
        offset: anchorOffset,
        follower: AlignmentDirectional.bottomCenter,
        target: AlignmentDirectional(reverse ? -1 : 1, -1),
      ),
      reaction: reactionIndicatorBuilder.call(context, message, onTap),
      child: child,
    );
  }
}
