// ignore_for_file: cascade_invocations

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/misc/size_change_listener.dart';

/// Signature for building a custom ReactionBubble widget.
typedef ReactionBubbleBuilder = Widget Function(
  BuildContext context,
  ReactionBubbleConfig config,
  Widget child,
);

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
  })  : target = AlignmentDirectional.topEnd,
        follower = AlignmentDirectional.bottomCenter;

  /// Creates an anchor that positions the bubble at the top-start of the
  /// target widget.
  const ReactionBubbleAnchor.topStart({
    this.offset = Offset.zero,
    this.shiftToWithinBound = const AxisFlag(x: true),
  })  : target = AlignmentDirectional.topStart,
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
class ReactionBubbleOverlay extends StatefulWidget {
  const ReactionBubbleOverlay({
    super.key,
    this.visible = true,
    required this.child,
    required this.reaction,
    this.childSizeDelta = Offset.zero,
    this.builder = _defaultBuilder,
    this.config = const ReactionBubbleConfig(),
    this.anchor = const ReactionBubbleAnchor.topEnd(),
  });

  /// The target child widget to anchor the reaction bubble to.
  final Widget child;

  /// The reaction widget to display inside the bubble.
  final Widget reaction;

  /// Whether the reaction bubble is visible.
  final bool visible;

  /// Optional adjustment to the child's reported size.
  final Offset childSizeDelta;

  /// The configuration used for rendering the reaction bubble.
  final ReactionBubbleConfig config;

  /// The anchor configuration to control bubble positioning.
  final ReactionBubbleAnchor anchor;

  /// The builder used to create the bubble appearance.
  final ReactionBubbleBuilder builder;

  static Widget _defaultBuilder(
    BuildContext context,
    ReactionBubbleConfig config,
    Widget child,
  ) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ReactionBubblePainter(config: config),
        child: child,
      ),
    );
  }

  @override
  State<ReactionBubbleOverlay> createState() => _ReactionBubbleOverlayState();
}

class _ReactionBubbleOverlayState extends State<ReactionBubbleOverlay> {
  Size? _childSize;

  /// Calculates the alignment for the bubble tail relative to the bubble rect.
  AlignmentGeometry _calculateTailAlignment({
    required Size childSize,
    required Rect bubbleRect,
    required Size availableSpace,
    bool reverse = false,
  }) {
    final childEdgeX = switch (reverse) {
      true => availableSpace.width - childSize.width,
      false => childSize.width
    };

    final idealBubbleLeft = childEdgeX - (bubbleRect.width / 2);
    final maxLeft = availableSpace.width - bubbleRect.width;
    final actualBubbleLeft = idealBubbleLeft.clamp(0, math.max(0, maxLeft));
    final tailOffset = childEdgeX - actualBubbleLeft;

    if (tailOffset == 0) return AlignmentDirectional.bottomCenter;
    return AlignmentDirectional((tailOffset * 2 / bubbleRect.width) - 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    final child = SizeChangeListener(
      onSizeChanged: (size) => setState(() => _childSize = size),
      child: widget.child,
    );

    final childSize = _childSize;
    // If the child size is not available or the overlay should not be visible,
    // return the child without any overlay.
    if (childSize == null || !widget.visible) return child;

    final alignment = widget.anchor;
    final direction = Directionality.maybeOf(context);
    final targetAlignment = alignment.target.resolve(direction);
    final followerAlignment = alignment.follower.resolve(direction);
    final availableSpace = MediaQuery.sizeOf(context);

    final reverse = targetAlignment.x < 0;
    final config = widget.config.copyWith(
      flipTail: reverse,
      tailAlignment: (bubbleRect) {
        final alignment = _calculateTailAlignment(
          reverse: reverse,
          bubbleRect: bubbleRect,
          availableSpace: availableSpace,
          childSize: childSize + widget.childSizeDelta,
        );

        return alignment.resolve(direction);
      },
    );

    return PortalTarget(
      anchor: Aligned(
        target: targetAlignment,
        follower: followerAlignment,
        offset: widget.anchor.offset,
        shiftToWithinBound: widget.anchor.shiftToWithinBound,
      ),
      portalFollower: widget.builder(context, config, widget.reaction),
      child: child,
    );
  }
}

/// Defines the visual configuration of a ReactionBubble.
class ReactionBubbleConfig {
  const ReactionBubbleConfig({
    this.flipTail = false,
    this.fillColor,
    this.maskColor,
    this.borderColor,
    this.maskWidth = 2.0,
    this.borderWidth = 1.0,
    this.bigTailCircleRadius = 4.0,
    this.smallTailCircleRadius = 2.0,
    this.tailAlignment = _defaultTailAlignment,
  });

  /// Whether to flip the tail horizontally.
  final bool flipTail;

  /// Fill color of the bubble.
  final Color? fillColor;

  /// Mask color of the bubble (used for visual masking).
  final Color? maskColor;

  /// Border color of the bubble.
  final Color? borderColor;

  /// Width of the mask stroke.
  final double maskWidth;

  /// Width of the border stroke.
  final double borderWidth;

  /// Radius of the larger circle at the bubble tail.
  final double bigTailCircleRadius;

  /// Radius of the smaller circle at the bubble tail.
  final double smallTailCircleRadius;

  /// Function that defines the alignment of the tail within the bubble rect.
  final Alignment Function(Rect) tailAlignment;

  static Alignment _defaultTailAlignment(Rect rect) => Alignment.bottomCenter;

  /// The total height contribution of the bubble tail.
  double get tailHeight => bigTailCircleRadius * 2 + smallTailCircleRadius * 2;

  /// Returns a copy of this config with optional overrides.
  ReactionBubbleConfig copyWith({
    bool? flipTail,
    Color? fillColor,
    Color? maskColor,
    Color? borderColor,
    double? maskWidth,
    double? borderWidth,
    double? bigTailCircleRadius,
    double? smallTailCircleRadius,
    Alignment Function(Rect)? tailAlignment,
  }) {
    return ReactionBubbleConfig(
      flipTail: flipTail ?? this.flipTail,
      fillColor: fillColor ?? this.fillColor,
      maskColor: maskColor ?? this.maskColor,
      borderColor: borderColor ?? this.borderColor,
      maskWidth: maskWidth ?? this.maskWidth,
      borderWidth: borderWidth ?? this.borderWidth,
      bigTailCircleRadius: bigTailCircleRadius ?? this.bigTailCircleRadius,
      smallTailCircleRadius:
          smallTailCircleRadius ?? this.smallTailCircleRadius,
      tailAlignment: tailAlignment ?? this.tailAlignment,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReactionBubbleConfig &&
        runtimeType == other.runtimeType &&
        flipTail == other.flipTail &&
        fillColor == other.fillColor &&
        maskColor == other.maskColor &&
        borderColor == other.borderColor &&
        maskWidth == other.maskWidth &&
        borderWidth == other.borderWidth &&
        bigTailCircleRadius == other.bigTailCircleRadius &&
        smallTailCircleRadius == other.smallTailCircleRadius &&
        tailAlignment == other.tailAlignment;
  }

  @override
  int get hashCode =>
      flipTail.hashCode ^
      fillColor.hashCode ^
      maskColor.hashCode ^
      borderColor.hashCode ^
      maskWidth.hashCode ^
      borderWidth.hashCode ^
      bigTailCircleRadius.hashCode ^
      smallTailCircleRadius.hashCode ^
      tailAlignment.hashCode;
}

/// A CustomPainter that draws a ReactionBubble based on a ReactionBubbleConfig.
class ReactionBubblePainter extends CustomPainter {
  /// Creates a [ReactionBubblePainter] with the specified configuration.
  ReactionBubblePainter({
    this.config = const ReactionBubbleConfig(),
  })  : _fillPaint = Paint()
          ..color = config.fillColor ?? Colors.white
          ..style = PaintingStyle.fill,
        _maskPaint = Paint()
          ..color = config.maskColor ?? Colors.white
          ..style = PaintingStyle.fill,
        _borderPaint = Paint()
          ..color = config.borderColor ?? Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = config.borderWidth;

  /// Configuration used to style the bubble.
  final ReactionBubbleConfig config;

  final Paint _fillPaint;
  final Paint _borderPaint;
  final Paint _maskPaint;

  @override
  void paint(Canvas canvas, Size size) {
    final tailHeight = config.tailHeight;
    final fullHeight = size.height + tailHeight;
    final bubbleHeight = fullHeight - tailHeight;
    final bubbleWidth = size.width;

    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(0, 0, bubbleWidth, bubbleHeight),
      Radius.circular(bubbleHeight / 2),
    );

    final alignment = config.tailAlignment.call(bubbleRect.outerRect);
    final bigTailCircleCenter = alignment.withinRect(bubbleRect.tallMiddleRect);

    final bigTailCircleRect = Rect.fromCircle(
      center: bigTailCircleCenter,
      radius: config.bigTailCircleRadius,
    );

    final smallTailCircleOffset = Offset(
      config.flipTail ? bigTailCircleRect.right : bigTailCircleRect.left,
      bigTailCircleRect.bottom + config.smallTailCircleRadius,
    );

    final smallTailCircleRect = Rect.fromCircle(
      center: smallTailCircleOffset,
      radius: config.smallTailCircleRadius,
    );

    final reactionBubbleMaskPath = _buildCombinedPath(
      bubbleRect.inflate(config.maskWidth),
      bigTailCircleRect.inflate(config.maskWidth),
      smallTailCircleRect.inflate(config.maskWidth),
    );

    canvas.drawPath(reactionBubbleMaskPath, _maskPaint);

    final reactionBubblePath = _buildCombinedPath(
      bubbleRect,
      bigTailCircleRect,
      smallTailCircleRect,
    );

    canvas.drawPath(reactionBubblePath, _borderPaint);
    canvas.drawPath(reactionBubblePath, _fillPaint);
  }

  /// Builds a combined path of the bubble and tail circles.
  Path _buildCombinedPath(
    RRect bubble,
    Rect bigCircle,
    Rect smallCircle,
  ) {
    final bubblePath = Path()..addRRect(bubble);
    final bigTailPath = Path()..addOval(bigCircle);
    final smallTailPath = Path()..addOval(smallCircle);

    return Path.combine(
      PathOperation.union,
      Path.combine(PathOperation.union, bubblePath, bigTailPath),
      smallTailPath,
    );
  }

  @override
  bool shouldRepaint(covariant ReactionBubblePainter oldDelegate) {
    return true;
  }
}
