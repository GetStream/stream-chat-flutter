import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ReactionBubble extends StatelessWidget {
  const ReactionBubble({
    Key key,
    @required this.reactions,
    @required this.borderColor,
    @required this.backgroundColor,
    this.reverse = false,
    this.flipTail = false,
  }) : super(key: key);

  final List<Reaction> reactions;
  final Color borderColor;
  final Color backgroundColor;
  final bool reverse;
  final bool flipTail;

  @override
  Widget build(BuildContext context) {
    final reactionAssets = StreamChatTheme.of(context).reactionIcons;
    return Transform(
      transform: Matrix4.rotationY(reverse ? pi : 0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment:
            flipTail ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
              ),
              color: backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: Wrap(
              children: [
                ...reactions.map((reaction) {
                  final reactionAsset = reactionAssets.firstWhere(
                    (reactionAsset) => reactionAsset.type == reaction.type,
                    orElse: () => null,
                  );
                  if (reactionAsset == null) {
                    return Text(
                      '?',
                      style: TextStyle(
                        color: StreamChatTheme.of(context).accentColor,
                      ),
                    );
                  }

                  return Icon(
                    reactionAsset.iconData,
                    size: 16,
                    color: StreamChatTheme.of(context).accentColor,
                  );
                }).toList(),
              ],
            ),
          ),
          _buildReactionsTail(context),
        ],
      ),
    );
  }

  Widget _buildReactionsTail(BuildContext context) {
    final tail = Transform.translate(
      offset: Offset(reactions.length > 1 ? -9 : -9, 0),
      child: CustomPaint(
        painter: ReactionBubblePainter(
          backgroundColor,
          borderColor,
          reactions.length,
        ),
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
  final int reactionsCount;

  ReactionBubblePainter(
    this.color,
    this.borderColor,
    this.reactionsCount,
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
        center: Offset(6, 2),
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
      center: Offset(6, 2),
      radius: 2,
    ));
    canvas.drawPath(path, paint);
  }

  void _drawBorder(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dy = reactionsCount > 1 ? -2.0 : -3.0;
    final startAngle = reactionsCount > 1 ? 1.08 : 1.16;
    final sweepAngle = reactionsCount > 1 ? 0.95 : 1.1;
    final path = Path();
    path.addArc(
      Rect.fromCircle(
        center: Offset(0, dy),
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

    final dy = reactionsCount > 1 ? -2.0 : -3.0;
    final startAngle = reactionsCount > 1 ? 1 : 1.16;
    final sweepAngle = reactionsCount > 1 ? 1.2 : 1;
    final path = Path();
    path.addArc(
      Rect.fromCircle(
        center: Offset(0, dy),
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
