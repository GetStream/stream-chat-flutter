import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_chat_flutter/src/reaction_icon.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ReactionBubble extends StatelessWidget {
  const ReactionBubble({
    Key key,
    @required this.reactions,
    @required this.borderColor,
    @required this.backgroundColor,
    this.reverse = false,
    this.flipTail = false,
    this.highlightOwnReactions = true,
  }) : super(key: key);

  final List<Reaction> reactions;
  final Color borderColor;
  final Color backgroundColor;
  final bool reverse;
  final bool flipTail;
  final bool highlightOwnReactions;

  @override
  Widget build(BuildContext context) {
    final reactionIcons = StreamChatTheme.of(context).reactionIcons;
    final offset = reactions.length > 1 ? 16.0 : 2.0;
    return Transform(
      transform: Matrix4.rotationY(reverse ? pi : 0),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(reverse ? offset : -offset, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor,
                ),
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Flex(
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (constraints.maxWidth < double.infinity)
                        ...reactions
                            .take((constraints.maxWidth) ~/ 22)
                            .map((reaction) {
                          return _buildReaction(
                            reactionIcons,
                            reaction,
                            context,
                          );
                        }).toList(),
                      if (constraints.maxWidth == double.infinity)
                        ...reactions.map((reaction) {
                          return _buildReaction(
                            reactionIcons,
                            reaction,
                            context,
                          );
                        }).toList(),
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: reverse ? null : 11,
            right: !reverse ? null : 11,
            child: _buildReactionsTail(context),
          ),
        ],
      ),
    );
  }

  Widget _buildReaction(
    List<ReactionIcon> reactionIcons,
    Reaction reaction,
    BuildContext context,
  ) {
    final reactionIcon = reactionIcons.firstWhere(
      (r) => r.type == reaction.type,
      orElse: () => null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: Icon(
        reactionIcon?.iconData ?? Icons.help_outline_rounded,
        size: 16,
        color: (!highlightOwnReactions ||
                reaction.user.id == StreamChat.of(context).user.id)
            ? StreamChatTheme.of(context).accentColor
            : Colors.black.withOpacity(.5),
      ),
    );
  }

  Widget _buildReactionsTail(BuildContext context) {
    final tail = CustomPaint(
      painter: ReactionBubblePainter(
        backgroundColor,
        borderColor,
      ),
    );

    if (!flipTail) {
      return tail;
    } else {
      return Transform(
        transform: Matrix4.rotationY(pi),
        alignment: Alignment.center,
        child: tail,
      );
    }
  }
}

class ReactionBubblePainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  ReactionBubblePainter(
    this.color,
    this.borderColor,
  );

  @override
  void paint(Canvas canvas, Size size) {
    _drawOval(size, canvas);

    _drawOvalBorder(size, canvas);

    _drawArc(size, canvas);

    _drawBorder(size, canvas);
  }

  void _drawOvalBorder(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(4, 3),
        radius: 2,
      ),
    );
    canvas.drawPath(path, paint);
  }

  void _drawOval(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    final path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(4, 3),
      radius: 2,
    ));
    canvas.drawPath(path, paint);
  }

  void _drawBorder(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dy = -2.2;
    final startAngle = 1.1;
    final sweepAngle = 1.2;
    final path = Path();
    path.addArc(
      Rect.fromCircle(
        center: Offset(1, dy),
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

    final dy = -2.2;
    final startAngle = 1;
    final sweepAngle = 1.3;
    final path = Path();
    path.addArc(
      Rect.fromCircle(
        center: Offset(1, dy),
        radius: 4,
      ),
      -pi * startAngle,
      -pi * sweepAngle,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
