import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// A custom painter that animates a circle border or fills it based on a
/// progress value.
///
/// This painter draws a circle with a border that can be animated to fill the
/// circle or stroke its outline based on a given progress value. The progress
/// value is a double between 0.0 and 1.0, representing the completion of the
/// animation.
///
/// When the progress is 0.0, the circle is completely empty, and when the
/// progress is 1.0, the circle is fully filled or stroked.
///
/// The color of the arc/circle can be customized by providing a [color].
///
/// Example usage:
/// ```dart
/// AnimatedCircleBorderPainter painter = AnimatedCircleBorderPainter(
///   progress: 0.5,
///   color: Colors.blue,
/// );
///
/// CustomPaint(
///   painter: painter,
///   size: Size(200, 200),
///   // ... other properties
/// )
/// ```
class AnimatedCircleBorderPainter extends CustomPainter {
  /// Creates an [AnimatedCircleBorderPainter] with the specified [progress]
  /// and [color].
  const AnimatedCircleBorderPainter({
    required this.progress,
    required this.color,
  });

  /// The progress of the animation, as a value between 0.0 and 1.0.
  final double progress;

  /// The color of the arc/circle.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final style = progress == 1.0 ? PaintingStyle.fill : PaintingStyle.stroke;

    final arcPaint = Paint()
      ..style = style
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final sweepAngle = math.pi * 2 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(AnimatedCircleBorderPainter oldPainter) {
    return oldPainter.progress != progress || oldPainter.color != color;
  }
}
