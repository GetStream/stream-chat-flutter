import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template threadReplyPainter}
/// A custom painter used to render thread replies.
///
/// Used in [BottomRow].
/// {@endtemplate}
class ThreadReplyPainter extends CustomPainter {
  /// {@macro threadReplyPainter}
  const ThreadReplyPainter({
    this.context,
    required this.color,
    this.reverse = false,
  });

  /// The color to paint the thread reply with.
  final Color? color;

  /// The [BuildContext] to use to retrieve the [StreamChatTheme].
  final BuildContext? context;

  /// {@macro reverse}
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
