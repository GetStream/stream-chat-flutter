import 'dart:math';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro reaction_bubble}
@Deprecated("Use 'StreamReactionBubble' instead")
typedef ReactionBubble = StreamReactionBubble;

/// {@template reaction_bubble}
/// Creates reaction bubble widget for displaying over messages
/// {@endtemplate}
class StreamReactionBubble extends StatelessWidget {
  /// Constructor for creating a [StreamReactionBubble]
  const StreamReactionBubble({
    Key? key,
    required this.reactions,
    required this.borderColor,
    required this.backgroundColor,
    required this.maskColor,
    this.reverse = false,
    this.flipTail = false,
    this.highlightOwnReactions = true,
    this.tailCirclesSpacing = 0,
  }) : super(key: key);

  /// Reactions to show
  final List<Reaction> reactions;

  /// Border color of bubble
  final Color borderColor;

  /// Background color of bubble
  final Color backgroundColor;

  /// Mask color
  final Color maskColor;

  /// Reverse for other side
  final bool reverse;

  /// Reverse tail for other side
  final bool flipTail;

  /// Flag for highlighting own reactions
  final bool highlightOwnReactions;

  /// Spacing for tail circles
  final double tailCirclesSpacing;

  @override
  Widget build(BuildContext context) {
    final reactionIcons = StreamChatTheme.of(context).reactionIcons;
    final totalReactions = reactions.length;
    final offset =
        totalReactions > 1 ? 16.0.mirrorConditionally(flipTail) : 2.0;
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(-offset, 0),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: maskColor,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: totalReactions > 1 ? 4.0 : 0,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor,
                ),
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) => Flex(
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (constraints.maxWidth < double.infinity)
                      ...reactions
                          .take((constraints.maxWidth) ~/ 24)
                          .map((reaction) => _buildReaction(
                                reactionIcons,
                                reaction,
                                context,
                              ))
                          .toList(),
                    if (constraints.maxWidth == double.infinity)
                      ...reactions
                          .map((reaction) => _buildReaction(
                                reactionIcons,
                                reaction,
                                context,
                              ))
                          .toList(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 2,
          left: reverse ? null : 13,
          right: reverse ? 13 : null,
          child: _buildReactionsTail(context),
        ),
      ],
    );
  }

  Widget _buildReaction(
    List<StreamReactionIcon> reactionIcons,
    Reaction reaction,
    BuildContext context,
  ) {
    final reactionIcon = reactionIcons.firstWhereOrNull(
      (r) => r.type == reaction.type,
    );

    final chatThemeData = StreamChatTheme.of(context);
    final userId = StreamChat.of(context).currentUser?.id;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: reactionIcon != null
          ? ConstrainedBox(
              constraints: BoxConstraints.tight(const Size.square(16)),
              child: reactionIcon.builder(
                context,
                !highlightOwnReactions || reaction.user?.id == userId,
                16,
              ),
            )
          : Icon(
              Icons.help_outline_rounded,
              size: 16,
              color: (!highlightOwnReactions || reaction.user?.id == userId)
                  ? chatThemeData.colorTheme.accentPrimary
                  : chatThemeData.colorTheme.textHighEmphasis.withOpacity(0.5),
            ),
    );
  }

  Widget _buildReactionsTail(BuildContext context) {
    final tail = CustomPaint(
      painter: ReactionBubblePainter(
        backgroundColor,
        borderColor,
        maskColor,
        tailCirclesSpace: tailCirclesSpacing,
        flipTail: !flipTail,
        numberOfReactions: reactions.length,
      ),
    );
    return tail;
  }
}

/// Painter widget for a reaction bubble
class ReactionBubblePainter extends CustomPainter {
  /// Constructor for creating a [ReactionBubblePainter]
  ReactionBubblePainter(
    this.color,
    this.borderColor,
    this.maskColor, {
    this.tailCirclesSpace = 0,
    this.flipTail = false,
    this.numberOfReactions = 0,
  });

  /// Color of bubble
  final Color color;

  /// Border color of bubble
  final Color borderColor;

  /// Mask color
  final Color maskColor;

  /// Tail circle space
  final double tailCirclesSpace;

  /// Flip tail
  final bool flipTail;

  /// Number of reactions on the page
  final int numberOfReactions;

  @override
  void paint(Canvas canvas, Size size) {
    _drawOvalMask(size, canvas);

    _drawMask(size, canvas);

    _drawOval(size, canvas);

    _drawOvalBorder(size, canvas);

    _drawArc(size, canvas);

    _drawBorder(size, canvas);
  }

  void _drawOvalMask(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = maskColor
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addOval(
        Rect.fromCircle(
          center: const Offset(4, 3).mirrorConditionally(flipTail) +
              Offset(tailCirclesSpace, tailCirclesSpace)
                  .mirrorConditionally(flipTail),
          radius: 4,
        ),
      );
    canvas.drawPath(path, paint);
  }

  void _drawOvalBorder(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addOval(
        Rect.fromCircle(
          center: const Offset(4, 3).mirrorConditionally(flipTail) +
              Offset(tailCirclesSpace, tailCirclesSpace)
                  .mirrorConditionally(flipTail),
          radius: 2,
        ),
      );
    canvas.drawPath(path, paint);
  }

  void _drawOval(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    final path = Path()
      ..addOval(Rect.fromCircle(
        center: const Offset(4, 3).mirrorConditionally(flipTail) +
            Offset(tailCirclesSpace, tailCirclesSpace)
                .mirrorConditionally(flipTail),
        radius: 2,
      ));
    canvas.drawPath(path, paint);
  }

  void _drawBorder(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dy = -2.2;
    final startAngle = flipTail ? -0.1 : 1.1;
    final sweepAngle = flipTail ? -1.2 : (numberOfReactions > 1 ? 1.2 : 0.9);
    final path = Path()
      ..addArc(
        Rect.fromCircle(
          center: const Offset(1, dy).mirrorConditionally(flipTail),
          radius: 4,
        ),
        -pi * startAngle,
        -pi / sweepAngle,
      );
    canvas.drawPath(path, paint);
  }

  void _drawArc(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const dy = -2.2;
    final startAngle = flipTail ? -0.0 : 1.0;
    final sweepAngle = flipTail ? -1.3 : 1.3;
    final path = Path()
      ..addArc(
        Rect.fromCircle(
          center: const Offset(1, dy).mirrorConditionally(flipTail),
          radius: 4,
        ),
        -pi * startAngle,
        -pi * sweepAngle,
      );
    canvas.drawPath(path, paint);
  }

  void _drawMask(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = maskColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    const dy = -2.2;
    final startAngle = flipTail ? -0.1 : 1.1;
    final sweepAngle = flipTail ? -1.2 : 1.2;
    final path = Path()
      ..addArc(
        Rect.fromCircle(
          center: const Offset(1, dy).mirrorConditionally(flipTail),
          radius: 6,
        ),
        -pi * startAngle,
        -pi / sweepAngle,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// Extension on [Offset]
extension YTransformer on Offset {
  /// Flips x coordinate when flip is true
  // ignore: avoid_positional_boolean_parameters
  Offset mirrorConditionally(bool flip) => Offset(flip ? -dx : dx, dy);
}

/// Extension on [Offset]
extension IntTransformer on double {
  /// Flips x coordinate when flip is true
  // ignore: avoid_positional_boolean_parameters
  double mirrorConditionally(bool flip) => flip ? -this : this;
}
