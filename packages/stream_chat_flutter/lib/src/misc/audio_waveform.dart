import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/audio_waveform_slider_theme.dart';
import 'package:stream_chat_flutter/src/theme/audio_waveform_theme.dart';

const _kAudioWaveformSliderThumbWidth = 4.0;
const _kAudioWaveformSliderThumbHeight = 28.0;

/// {@template streamAudioWaveformSlider}
/// A widget that displays an audio waveform and allows the user to interact
/// with it using a slider.
/// {@endtemplate}
class StreamAudioWaveformSlider extends StatefulWidget {
  /// {@macro streamAudioWaveformSlider}
  const StreamAudioWaveformSlider({
    super.key,
    required this.waveform,
    this.onChangeStart,
    required this.onChanged,
    this.onChangeEnd,
    this.limit = 100,
    this.color,
    this.progress = 0,
    this.progressColor,
    this.minBarHeight,
    this.spacingRatio,
    this.heightScale,
    this.inverse = true,
    this.thumbColor,
    this.thumbBorderColor,
  });

  /// The waveform data to be drawn.
  ///
  /// Note: The values should be between 0 and 1.
  final List<double> waveform;

  /// Called when the thumb starts being dragged.
  final ValueChanged<double>? onChangeStart;

  /// Called while the thumb is being dragged.
  final ValueChanged<double>? onChanged;

  /// Called when the thumb stops being dragged.
  final ValueChanged<double>? onChangeEnd;

  /// The color of the wave bars.
  ///
  /// Defaults to [StreamAudioWaveformSliderThemeData.color].
  final Color? color;

  /// The number of wave bars that will be draw in the screen. When the length
  /// of [waveform] is bigger than [limit] only the X last bars will be shown.
  ///
  /// Defaults to 100.
  final int limit;

  /// The progress of the audio track. Used to show the progress of the audio.
  ///
  /// Defaults to 0.
  final double progress;

  /// The color of the progressed wave bars.
  ///
  /// Defaults to [StreamAudioWaveformSliderThemeData.progressColor].
  final Color? progressColor;

  /// The minimum height of the bars.
  ///
  /// Defaults to [StreamAudioWaveformSliderThemeData.minBarHeight].
  final double? minBarHeight;

  /// The ratio of the spacing between the bars.
  ///
  /// Defaults to [StreamAudioWaveformSliderThemeData.spacingRatio].
  final double? spacingRatio;

  /// The scale of the height of the bars.
  ///
  /// Defaults to [StreamAudioWaveformSliderThemeData.heightScale].
  final double? heightScale;

  /// If true, the bars grow from right to left otherwise they grow from left
  /// to right.
  ///
  /// Defaults to true.
  final bool inverse;

  /// The color of the slider thumb.
  ///
  /// Defaults to [StreamAudioWaveformSliderThemeData.thumbColor].
  final Color? thumbColor;

  /// The color of the slider thumb border.
  ///
  /// Defaults to [StreamAudioWaveformSliderThemeData.thumbBorderColor].
  final Color? thumbBorderColor;

  @override
  State<StreamAudioWaveformSlider> createState() => _StreamAudioWaveformSliderState();
}

class _StreamAudioWaveformSliderState extends State<StreamAudioWaveformSlider> {
  @override
  Widget build(BuildContext context) {
    final theme = StreamAudioWaveformSliderTheme.of(context);
    final waveformTheme = theme.audioWaveformTheme;

    final color = widget.color ?? waveformTheme!.color!;
    final progressColor = widget.progressColor ?? waveformTheme!.progressColor!;
    final minBarHeight = widget.minBarHeight ?? waveformTheme!.minBarHeight!;
    final spacingRatio = widget.spacingRatio ?? waveformTheme!.spacingRatio!;
    final heightScale = widget.heightScale ?? waveformTheme!.heightScale!;
    final thumbColor = widget.thumbColor ?? theme.thumbColor!;
    final thumbBorderColor = widget.thumbBorderColor ?? theme.thumbBorderColor!;

    return HorizontalSlider(
      onChangeStart: widget.onChangeStart,
      onChanged: widget.onChanged,
      onChangeEnd: widget.onChangeEnd,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            StreamAudioWaveform(
              waveform: widget.waveform,
              limit: widget.limit,
              color: color,
              progress: widget.progress,
              progressColor: progressColor,
              minBarHeight: minBarHeight,
              spacingRatio: spacingRatio,
              heightScale: heightScale,
              inverse: widget.inverse,
            ),
            Builder(
              // Just using it for the calculation of the thumb position.
              builder: (context) {
                final progressWidth = constraints.maxWidth * widget.progress;
                return AnimatedPositioned(
                  curve: const ElasticOutCurve(1.05),
                  duration: const Duration(milliseconds: 300),
                  left: progressWidth - _kAudioWaveformSliderThumbWidth / 2,
                  child: StreamAudioWaveformSliderThumb(
                    color: thumbColor,
                    borderColor: thumbBorderColor,
                    height: constraints.maxHeight,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// {@template streamAudioWaveformSliderThumb}
/// A widget that represents the thumb of the [StreamAudioWaveformSlider].
/// {@endtemplate}
class StreamAudioWaveformSliderThumb extends StatelessWidget {
  /// {@macro streamAudioWaveformSliderThumb}
  const StreamAudioWaveformSliderThumb({
    super.key,
    this.width = _kAudioWaveformSliderThumbWidth,
    this.height = _kAudioWaveformSliderThumbHeight,
    this.color = Colors.white,
    this.borderColor = const Color(0xffecebeb),
  });

  /// The width of the thumb.
  final double width;

  /// The height of the thumb.
  final double height;

  /// The color of the thumb.
  final Color color;

  /// The border color of the thumb.
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: borderColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// {@template streamAudioWaveform}
/// A widget that displays an audio waveform.
///
/// The waveform is drawn using the [waveform] data. The waveform is drawn
/// horizontally and the bars grow from right to left.
/// {@endtemplate}
class StreamAudioWaveform extends StatelessWidget {
  /// {@macro streamAudioWaveform}
  const StreamAudioWaveform({
    super.key,
    required this.waveform,
    this.limit = 100,
    this.color,
    this.progress = 0,
    this.progressColor,
    this.minBarHeight,
    this.spacingRatio,
    this.heightScale,
    this.inverse = true,
  });

  /// The waveform data to be drawn.
  ///
  /// Note: The values should be between 0 and 1.
  final List<double> waveform;

  /// The color of the wave bars.
  ///
  /// Defaults to [StreamAudioWaveformThemeData.color].
  final Color? color;

  /// The number of wave bars that will be draw in the screen. When the length
  /// of [waveform] is bigger than [limit] only the X last bars will be shown.
  ///
  /// Defaults to 100.
  final int limit;

  /// The progress of the audio track. Used to show the progress of the audio.
  ///
  /// Defaults to 0.
  final double progress;

  /// The color of the progressed wave bars.
  ///
  /// Defaults to [StreamAudioWaveformThemeData.progressColor].
  final Color? progressColor;

  /// The minimum height of the bars.
  ///
  /// Defaults to [StreamAudioWaveformThemeData.minBarHeight].
  final double? minBarHeight;

  /// The ratio of the spacing between the bars.
  ///
  /// Defaults to [StreamAudioWaveformThemeData.spacingRatio].
  final double? spacingRatio;

  /// The scale of the height of the bars.
  ///
  /// Defaults to [StreamAudioWaveformThemeData.heightScale].
  final double? heightScale;

  /// If true, the bars grow from right to left otherwise they grow from left
  /// to right.
  ///
  /// Defaults to true.
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    final theme = StreamAudioWaveformTheme.of(context);

    final color = this.color ?? theme.color!;
    final progressColor = this.progressColor ?? theme.progressColor!;
    final minBarHeight = this.minBarHeight ?? theme.minBarHeight!;
    final spacingRatio = this.spacingRatio ?? theme.spacingRatio!;
    final heightScale = this.heightScale ?? theme.heightScale!;

    return CustomPaint(
      willChange: true,
      painter: _WaveformPainter(
        waveform: waveform.reversed,
        limit: limit,
        color: color,
        progress: progress,
        progressColor: progressColor,
        minBarHeight: minBarHeight,
        spacingRatio: spacingRatio,
        heightScale: heightScale,
        inverse: inverse,
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required Iterable<double> waveform,
    this.limit = 100,
    this.color = const Color(0xff7E828B),
    this.progress = 0,
    this.progressColor = const Color(0xff005FFF),
    this.minBarHeight = 2,
    double spacingRatio = 0.3,
    this.heightScale = 1,
    this.inverse = true,
  }) : waveform = [
         ...waveform.take(limit),
         if (waveform.length < limit)
           // Fill the remaining bars with 0 value
           ...List.filled(limit - waveform.length, 0),
       ],
       spacingRatio = spacingRatio.clamp(0, 1);

  final List<double> waveform;
  final Color color;
  final int limit;
  final double progress;
  final Color progressColor;
  final double minBarHeight;
  final double spacingRatio;
  final bool inverse;
  final double heightScale;

  @override
  void paint(Canvas canvas, Size size) {
    final canvasWidth = size.width;
    final canvasHeight = size.height;

    // The total spacing between the bars in the canvas.
    final spacingWidth = canvasWidth * spacingRatio;
    final barsWidth = canvasWidth - spacingWidth;
    final barWidth = barsWidth / limit;
    final barSpacing = spacingWidth / (limit - 1);
    final progressWidth = progress * canvasWidth;

    void _paintBar(int index, double barValue) {
      var dx = index * (barWidth + barSpacing) + barWidth / 2;
      if (inverse) dx = canvasWidth - dx;
      final dy = canvasHeight / 2;

      final barHeight = math.max(barValue * canvasHeight, minBarHeight);

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(dx, dy),
          width: barWidth,
          height: barHeight,
        ),
        const Radius.circular(2),
      );

      final waveColor = switch (dx <= progressWidth) {
        true => progressColor,
        false => color,
      };

      final wavePaint = Paint()
        ..color = waveColor
        ..strokeCap = StrokeCap.round;

      canvas.drawRRect(rect, wavePaint);
    }

    // Paint all the bars
    waveform.forEachIndexed(_paintBar);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      !const ListEquality().equals(waveform, oldDelegate.waveform) ||
      color != oldDelegate.color ||
      limit != oldDelegate.limit ||
      progress != oldDelegate.progress ||
      progressColor != oldDelegate.progressColor ||
      minBarHeight != oldDelegate.minBarHeight ||
      spacingRatio != oldDelegate.spacingRatio ||
      heightScale != oldDelegate.heightScale ||
      inverse != oldDelegate.inverse;
}

/// {@template horizontalSlider}
/// A widget that allows interactive horizontal sliding gestures.
///
/// The `HorizontalSlider` widget wraps a child widget and allows users to
/// perform sliding gestures horizontally. It can be configured with callbacks
/// to notify the parent widget about the changes in the horizontal value.
/// {@endtemplate}
class HorizontalSlider extends StatefulWidget {
  /// Creates a horizontal slider.
  const HorizontalSlider({
    super.key,
    required this.child,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
  });

  /// The child widget wrapped by the slider.
  final Widget child;

  /// Called when the horizontal value starts changing.
  final ValueChanged<double>? onChangeStart;

  /// Called when the horizontal value changes.
  final ValueChanged<double>? onChanged;

  /// Called when the horizontal value stops changing.
  final ValueChanged<double>? onChangeEnd;

  @override
  State<HorizontalSlider> createState() => _HorizontalSliderState();
}

class _HorizontalSliderState extends State<HorizontalSlider> {
  bool _active = false;

  /// Returns true if the slider is interactive.
  bool get isInteractive => widget.onChanged != null;

  /// Converts the visual position to a value based on the text direction.
  double _getValueFromVisualPosition(double visualPosition) {
    final textDirection = Directionality.of(context);
    final value = switch (textDirection) {
      TextDirection.rtl => 1.0 - visualPosition,
      TextDirection.ltr => visualPosition,
    };

    return clampDouble(value, 0, 1);
  }

  /// Converts the local position to a horizontal value.
  double _getValueFromLocalPosition(Offset globalPosition) {
    final box = context.findRenderObject()! as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);
    final visualPosition = localPosition.dx / box.size.width;
    return _getValueFromVisualPosition(visualPosition);
  }

  void _handleDragStart(DragStartDetails details) {
    if (!_active && isInteractive) {
      _active = true;
      final value = _getValueFromLocalPosition(details.globalPosition);
      widget.onChangeStart?.call(value);
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _handleHorizontalDrag(details.globalPosition);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!mounted) return;

    if (_active && mounted) {
      final value = _getValueFromLocalPosition(details.globalPosition);
      widget.onChangeEnd?.call(value);
      _active = false;
    }
  }

  /// Handles the sliding gesture.
  void _handleHorizontalDrag(Offset globalPosition) {
    if (!mounted) return;

    if (isInteractive) {
      final value = _getValueFromLocalPosition(globalPosition);
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: widget.child,
    );
  }
}
