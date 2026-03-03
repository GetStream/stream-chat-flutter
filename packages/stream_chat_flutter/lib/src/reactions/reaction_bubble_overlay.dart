import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

/// Defines the anchor settings for positioning a ReactionBubble relative to a
/// target widget.
class ReactionBubbleAnchor {
  /// Creates an anchor with custom alignment and offset.
  const ReactionBubbleAnchor({
    this.offset = Offset.zero,
    required this.target,
    required this.follower,
    this.shiftToWithinBound = const AxisFlag(x: true),
  });

  /// Creates an anchor that positions the bubble at the top-end of the
  /// target widget.
  const ReactionBubbleAnchor.topEnd({
    this.offset = Offset.zero,
    this.shiftToWithinBound = const AxisFlag(x: true),
  }) : target = AlignmentDirectional.topEnd,
       follower = AlignmentDirectional.bottomCenter;

  /// Creates an anchor that positions the bubble at the top-start of the
  /// target widget.
  const ReactionBubbleAnchor.topStart({
    this.offset = Offset.zero,
    this.shiftToWithinBound = const AxisFlag(x: true),
  }) : target = AlignmentDirectional.topStart,
       follower = AlignmentDirectional.bottomCenter;

  /// Additional offset applied to the bubble position.
  final Offset offset;

  /// Target alignment relative to the target widget.
  final AlignmentDirectional target;

  /// Alignment of the bubble follower relative to the target alignment.
  final AlignmentDirectional follower;

  /// Whether to shift the bubble within the visible screen bounds along each
  /// axis if it exceeds the screen size.
  final AxisFlag shiftToWithinBound;
}

/// An overlay widget that displays a reaction bubble near a child widget.
class ReactionBubbleOverlay extends StatelessWidget {
  /// Creates a new instance of [ReactionBubbleOverlay].
  const ReactionBubbleOverlay({
    super.key,
    this.visible = true,
    required this.child,
    required this.reaction,
    this.anchor = const ReactionBubbleAnchor.topEnd(),
  });

  /// The target child widget to anchor the reaction bubble to.
  final Widget child;

  /// The reaction widget to display inside the bubble.
  final Widget reaction;

  /// Whether the reaction bubble is visible.
  final bool visible;

  /// The anchor configuration to control bubble positioning.
  final ReactionBubbleAnchor anchor;

  @override
  Widget build(BuildContext context) {
    // If the overlay should not be visible, return the child without any overlay.
    if (!visible) return child;

    final alignment = anchor;
    final direction = Directionality.maybeOf(context);
    final targetAlignment = alignment.target.resolve(direction);
    final followerAlignment = alignment.follower.resolve(direction);

    return PortalTarget(
      anchor: Aligned(
        target: targetAlignment,
        follower: followerAlignment,
        offset: anchor.offset,
        shiftToWithinBound: anchor.shiftToWithinBound,
      ),
      portalFollower: reaction,
      child: child,
    );
  }
}
