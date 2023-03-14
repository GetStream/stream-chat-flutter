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
    this.customSliderButton,
    this.customSliderButtonWidth,
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

  ///Docs
  final Widget? customSliderButton;

  ///Docs
  final double? customSliderButtonWidth;

  @override
  _AudioWaveSliderState createState() => _AudioWaveSliderState();
}

class _AudioWaveSliderState extends State<AudioWaveSlider> {
  var _dragging = false;
  final _initialWidth = 7.0;
  final _finalWidth = 14.0;
  final _initialHeight = 30.0;
  final _finalHeight = 35.0;
  final _padding = 10;

  double _currentWidth() {
    if (widget.customSliderButtonWidth != null) {
      return widget.customSliderButtonWidth!;
    } else {
      return _dragging ? _finalWidth : _initialWidth;
    }
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

        final sliderButton = widget.customSliderButton ??
            Container(
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
                    padding: _padding,
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
    required this.progressPercentage,
    this.spacingRatio = 0.01,
    this.colorLeft = Colors.blueAccent,
    this.colorRight = Colors.lightBlue,
    this.barHeightRatio = 1,
    this.padding = 20,
  });

  final List<double> bars;
  final Color colorRight;
  final Color colorLeft;
  final double progressPercentage;
  final double spacingRatio;
  final double barHeightRatio;
  final int padding;

  /// barWidth should include spacing, not only the width of the bar.
  /// progressX should be the middle of the moving button of the slider, not
  /// initial X position.
  Color _barColor(double buttonCenter, double progressX) {
    return (progressX > buttonCenter) ? colorRight : colorLeft;
  }

  double _barHeight(double barValue, totalHeight) {
    return max(barValue * totalHeight * barHeightRatio, 2);
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

  //Todo: Take a look in this method later.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
