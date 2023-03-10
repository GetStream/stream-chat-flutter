import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Docs
class AudioWaveSlider extends StatefulWidget {
  /// Docs
  const AudioWaveSlider({
    super.key,
    required this.bars,
    required this.progressStream,
    this.barsRatio = 1,
    this.onChangeStart,
    this.onChanged,
    this.onChangeEnd,
  });

  /// Docs
  final List<double> bars;

  /// Docs
  final Stream<double> progressStream;

  ///Docs
  final double barsRatio;

  ///Docs
  final Function(double)? onChangeStart;

  ///Docs
  final Function(double)? onChanged;

  ///Docs
  final Function()? onChangeEnd;

  @override
  _AudioWaveSliderState createState() => _AudioWaveSliderState();
}

class _AudioWaveSliderState extends State<AudioWaveSlider> {
  var _dragging = false;
  final _initialWidth = 7.0;
  final _finalWidth = 14.0;
  final _initialHeight = 30.0;
  final _finalHeight = 35.0;
  final _padding = 20;

  double _currentWidth() {
    return _dragging ? _finalWidth : _initialWidth;
  }

  double _currentHeight() {
    return _dragging ? _finalHeight : _initialHeight;
  }

  double _progressToWidth(BoxConstraints constraints, double progress) {
    final availableWidth = constraints.maxWidth - _padding * 2;

    return availableWidth * progress - _currentWidth() / 2 + _padding;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: 0,
      stream: widget.progressStream,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0;

        final sliderButton = Container(
          width: _currentWidth(),
          height: _currentHeight(),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6),
          ),
        );

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _AudioBarsPainter(
                    bars: widget.bars,
                    colorLeft: Colors.lightBlueAccent,
                    colorRight: Colors.blueAccent,
                    progressPercentage: progress,
                    barRatio: 1,
                    padding: _padding,
                    buttonWidth: _currentWidth(),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration.zero,
                  left: _progressToWidth(constraints, progress),
                  key: const ValueKey('item 1'),
                  child: sliderButton,
                ),
                GestureDetector(
                  onHorizontalDragStart: (details) {
                    widget.onChangeStart
                        ?.call(details.localPosition.dx / constraints.maxWidth);

                    setState(() {
                      _dragging = true;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    widget.onChangeEnd?.call();

                    setState(() {
                      _dragging = false;
                    });
                  },
                  onHorizontalDragUpdate: (details) {
                    widget.onChanged?.call(
                      min(
                        max(details.localPosition.dx / constraints.maxWidth, 0),
                        1,
                      ),
                    );
                  },
                ),
              ],
            );
          },
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
    required this.progressPercentage,
    required this.barRatio,
    required this.padding,
    required this.buttonWidth,
  });

  final List<double> bars;
  final Color colorRight;
  final Color colorLeft;
  final double progressPercentage;
  final spacingRatio = 0.005;
  final double barRatio;
  final int padding;
  final double buttonWidth;

  /// barWidth should include spacing, not only the width of the bar.
  /// progressX should be the middle of the moving button of the slider, not
  /// initial X position.
  Color _barColor(double buttonCenter, double progressX) {
    return (progressX > buttonCenter) ? colorRight : colorLeft;
  }

  double _barHeight(double barValue, totalHeight) {
    return max(barValue * totalHeight * barRatio, 2);
  }

  double _progressToWidth(double totalWidth, double progress) {
    final availableWidth = totalWidth;

    return availableWidth * progress + padding;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalWidth = size.width - padding * 2;

    final spacingWidth = totalWidth * spacingRatio;
    final totalBarWidth = totalWidth - spacingWidth * (bars.length - 1);
    final barWidth = totalBarWidth / bars.length;
    final barY = size.height / 2;

    bars.forEachIndexed((i, barValue) {
      final barHeight = _barHeight(barValue, size.height);
      final barX = i * (barWidth + spacingWidth) + barWidth / 2 + padding;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(barX, barY),
          width: barWidth,
          height: barHeight,
        ),
        const Radius.circular(50),
      );

      final paint = Paint()
        ..color = _barColor(
          barX + barWidth / 2,
          _progressToWidth(totalWidth, progressPercentage),
        );
      canvas.drawRRect(rect, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
