import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_chat_flutter/src/reaction_icon.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils/MainAppColorHelper.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ReactionBubble extends StatelessWidget {
  const ReactionBubble({
    Key key,
    @required this.reactions,
    @required this.borderColor,
    @required this.backgroundColor,
    @required this.maskColor,
    this.reverse = false,
    this.flipTail = false,
    this.highlightOwnReactions = true,
    this.tailCirclesSpacing = 0,
    this.reactionScores,
  }) : super(key: key);

  final List<Reaction> reactions;
  final Color borderColor;
  final Color backgroundColor;
  final Color maskColor;
  final bool reverse;
  final bool flipTail;
  final bool highlightOwnReactions;
  final double tailCirclesSpacing;
  final Map<String, int> reactionScores;

  @override
  Widget build(BuildContext context) {
    final reactionIcons = StreamChatTheme.of(context).reactionIcons;
    final totalReactions = reactions.length;
    final offset = totalReactions > 1 ? 16.0 : 2.0;
    return Transform(
      transform: Matrix4.rotationY(reverse ? pi : 0),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(reverse ? offset : -offset, 0),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: maskColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: totalReactions > 1 ? 4 : 0,
                ),
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
                              .take((constraints.maxWidth) ~/ 24)
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
          ),
          Positioned(
            bottom: 0,
            left: reverse ? null : 13,
            right: !reverse ? null : 13,
            child: _buildReactionsTail(context),
          ),
        ],
      ),
    );
  }

  int getReactionScore(String type) {
    if (reactionScores != null && reactionScores.isNotEmpty) {
      return reactionScores[type] ?? 0;
    }
    return 0;
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

    int count = getReactionScore(reaction.type);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: reactionIcon != null
          ? Stack(children: [
              reactionIcon.emoji == null
                  ? StreamSvgIcon(
                      assetName: reactionIcon.assetName,
                      width: 18,
                      height: 18,
                      color: MainAppColorHelper.orange(),
                      // (!highlightOwnReactions ||
                      //         reaction.user.id == StreamChat.of(context).user.id)
                      //     ? StreamChatTheme.of(context).colorTheme.accentBlue
                      //     : StreamChatTheme.of(context)
                      //         .colorTheme
                      //         .black
                      //         .withOpacity(.5),
                    )
                  : Text(
                      reactionIcon.emoji,
                      style: TextStyle(fontSize: 16),
                    ),
              Visibility(
                visible: count > 1 ? true : false,
                child: Positioned(
                    left: 10,
                    top: 9,
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Padding(
                          padding: EdgeInsets.all(1.5),
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                                fontSize: 8,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ))),
              ),
            ])
          : Icon(
              Icons.help_outline_rounded,
              size: 16,
              color: (!highlightOwnReactions ||
                      reaction.user.id == StreamChat.of(context).user.id)
                  ? MainAppColorHelper.orange()
                  : StreamChatTheme.of(context)
                      .colorTheme
                      .black
                      .withOpacity(.5),
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
      ),
    );
    return Transform(
      transform: Matrix4.rotationY(flipTail ? 0 : pi),
      alignment: Alignment.center,
      child: tail,
    );
  }
}

class ReactionBubblePainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final Color maskColor;
  final double tailCirclesSpace;

  ReactionBubblePainter(
    this.color,
    this.borderColor,
    this.maskColor, {
    this.tailCirclesSpace = 0,
  });

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

    final path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(4, 3) + Offset(tailCirclesSpace, tailCirclesSpace),
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

    final path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(4, 3) + Offset(tailCirclesSpace, tailCirclesSpace),
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
      center: Offset(4, 3) + Offset(tailCirclesSpace, tailCirclesSpace),
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

  void _drawMask(Size size, Canvas canvas) {
    final paint = Paint()
      ..color = maskColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final dy = -2.2;
    final startAngle = 1.1;
    final sweepAngle = 1.2;
    final path = Path();
    path.addArc(
      Rect.fromCircle(
        center: Offset(1, dy),
        radius: 6,
      ),
      -pi * startAngle,
      -pi / sweepAngle,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
