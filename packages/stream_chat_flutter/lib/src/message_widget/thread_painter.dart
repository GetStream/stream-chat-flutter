import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ThreadReplyPainter extends CustomPainter {
  const ThreadReplyPainter({
    this.context,
    required this.color,
    this.reverse = false,
  });

  final Color? color;
  final BuildContext? context;
  final bool reverse;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? StreamChatTheme.of(context!).colorTheme.disabled
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(reverse ? size.width : 0, 0)
      ..quadraticBezierTo(
        reverse ? size.width : 0,
        size.height * 0.38,
        reverse ? size.width : 0,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        reverse ? size.width : 0,
        size.height,
        reverse ? 0 : size.width,
        size.height,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
