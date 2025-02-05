import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template StreamVoiceRecordingSlider}
/// A Widget that draws the audio wave bars for an audio inside a Slider.
/// This Widget is indeed to be used to control the position of an audio message
/// and to get feedback of the position.
/// {@endtemplate}
@Deprecated("Use 'StreamAudioWaveformSlider' instead")
class StreamVoiceRecordingSlider extends StatefulWidget {
  /// {@macro StreamVoiceRecordingSlider}
  const StreamVoiceRecordingSlider({
    super.key,
    required this.waves,
    required this.progressStream,
    this.onChangeStart,
    this.onChanged,
    this.onChangeEnd,
    this.customSliderButton,
    this.customSliderButtonWidth,
  });

  /// The audio bars from 0.0 to 1.0.
  final List<double> waves;

  /// The progress of the audio.
  final Stream<double> progressStream;

  /// Callback called when Slider drag starts.
  final Function(double)? onChangeStart;

  /// Callback called when Slider drag updates.
  final Function(double)? onChanged;

  /// Callback called when Slider drag ends.
  final Function()? onChangeEnd;

  /// A custom Slider button. Use this to substitute the default rounded
  /// rectangle.
  final Widget? customSliderButton;

  /// The width of the customSliderButton. This should match the width of the
  /// provided Widget.
  final double? customSliderButtonWidth;

  @override
  _StreamVoiceRecordingSliderState createState() =>
      _StreamVoiceRecordingSliderState();
}

@Deprecated("Use 'StreamAudioWaveformSlider' instead")
class _StreamVoiceRecordingSliderState
    extends State<StreamVoiceRecordingSlider> {
  var _dragging = false;
  final _initialWidth = 7.0;
  final _finalWidth = 14.0;
  final _initialHeight = 30.0;
  final _finalHeight = 35.0;

  Duration get animationDuration =>
      _dragging ? Duration.zero : const Duration(milliseconds: 300);

  double get _currentWidth {
    if (widget.customSliderButtonWidth != null) {
      return widget.customSliderButtonWidth!;
    } else {
      return _dragging ? _finalWidth : _initialWidth;
    }
  }

  double get _currentHeight => _dragging ? _finalHeight : _initialHeight;

  double _progressToWidth(
      BoxConstraints constraints, double progress, double horizontalPadding) {
    final availableWidth = constraints.maxWidth - horizontalPadding * 2;

    return availableWidth * progress - _currentWidth / 2 + horizontalPadding;
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context).voiceRecordingTheme.sliderTheme;

    return StreamBuilder<double>(
      initialData: 0,
      stream: widget.progressStream,
      builder: (context, snapshot) {
        final progress = snapshot.data ?? 0;

        final sliderButton = widget.customSliderButton ??
            Container(
              width: _currentWidth,
              height: _currentHeight,
              decoration: BoxDecoration(
                color: theme.buttonColor,
                boxShadow: [
                  theme.buttonShadow!,
                ],
                border: Border.all(
                  color: theme.buttonBorderColor!,
                  width: theme.buttonBorderWidth!,
                ),
                borderRadius: theme.buttonBorderRadius,
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
                    bars: widget.waves,
                    spacingRatio: theme.spacingRatio,
                    barHeightRatio: theme.waveHeightRatio,
                    colorLeft: theme.waveColorPlayed!,
                    colorRight: theme.waveColorUnplayed!,
                    progressPercentage: progress,
                    padding: theme.horizontalPadding,
                  ),
                ),
                AnimatedPositioned(
                  duration: animationDuration,
                  left: _progressToWidth(
                      constraints, progress, theme.horizontalPadding),
                  curve: const ElasticOutCurve(1.05),
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
    this.colorLeft = Colors.blueAccent,
    this.colorRight = Colors.grey,
    this.spacingRatio = 0.01,
    this.barHeightRatio = 1,
    this.padding = 20,
  });

  final List<double> bars;
  final double progressPercentage;
  final Color colorRight;
  final Color colorLeft;
  final double spacingRatio;
  final double barHeightRatio;
  final double padding;

  /// barWidth should include spacing, not only the width of the bar.
  /// progressX should be the middle of the moving button of the slider, not
  /// initial X position.
  Color _barColor(double buttonCenter, double progressX) {
    return (progressX > buttonCenter) ? colorLeft : colorRight;
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
