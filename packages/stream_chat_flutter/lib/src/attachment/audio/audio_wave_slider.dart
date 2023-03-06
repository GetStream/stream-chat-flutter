import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

const double _maxBarHeight = 255;

/// Docs
class AudioWaveSlider extends StatefulWidget {
  /// Docs
  const AudioWaveSlider({
    super.key,
    required this.bars,
    required this.progressStream,
  });

  /// Docs
  final List<int> bars;

  /// Docs
  final Stream<double> progressStream;

  @override
  _AudioWaveSliderState createState() => _AudioWaveSliderState();
}

class _AudioWaveSliderState extends State<AudioWaveSlider> {
  var _dragging = false;
  final _initialSize = 15.0;
  final _finalSize = 22.0;

  double _currentSize() {
    return _dragging ? _finalSize : _initialSize;
  }

  double _maxWidth(BuildContext context) {
    return 160;
  }

  double _progressToWidth(BuildContext context, double progress) {
    return _maxWidth(context) * progress;
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = _maxWidth(context);
    final maxHeight = MediaQuery.of(context).size.height;

    final gestureDetector = GestureDetector(
      onHorizontalDragStart: (details) {
        setState(() {
          _dragging = true;
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _dragging = false;
        });
      },
      onHorizontalDragUpdate: (details) {},
    );

    return StreamBuilder<double>(
      initialData: 0,
      stream: widget.progressStream,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0;

        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(maxWidth, maxHeight),
              painter: _AudioBarsPainter(
                bars: widget.bars,
                colorLeft: Colors.lightBlueAccent,
                colorRight: Colors.blueAccent,
                progress:
                    _progressToWidth(context, progress),
              ),
            ),
            AnimatedPositioned(
              duration: Duration.zero,
              left: _progressToWidth(context, progress),
              key: const ValueKey('item 1'),
              child: Container(
                width: _currentSize(),
                height: _currentSize(),
                // color: Colors.red,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            ),
            gestureDetector,
          ],
        );
      },
    );
  }
}

class _AudioBarsPainter extends CustomPainter {
  _AudioBarsPainter({
    required this.bars,
    required this.colorLeft,
    required this.colorRight,
    required this.progress,
  });

  final List<int> bars;
  final Color colorRight;
  final Color colorLeft;
  final double progress;
  final spacingRatio = 0.005;

  /// barWidth should include spacing, not only the width of the bar.
  Color _barColor(double barCenter, double progress) {
    return (progress > barCenter) ? colorRight : colorLeft;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final spacingWidth = size.width * spacingRatio;
    final totalBarWidth = size.width - spacingWidth * (bars.length - 1);
    final barWidth = totalBarWidth / bars.length;
    final barY = size.height / 2;

    bars.forEachIndexed((i, bar) {
      final double barHeight = max((bar / _maxBarHeight) * size.height, 4);
      final barX = i * (barWidth + spacingWidth) + barWidth / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(barX, barY),
          width: barWidth,
          height: barHeight,
        ),
        const Radius.circular(50),
      );

      final paint = Paint()..color = _barColor(barX + barWidth / 2, progress);
      canvas.drawRRect(rect, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
