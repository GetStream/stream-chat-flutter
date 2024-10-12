import 'package:flutter/material.dart';

class AudioWaveBars extends StatelessWidget {
  final List<double> amplitudes;
  final double barWidth;
  final Color barColor;
  final Color backgroundColor;
  final Color barColorActive; // Color for active part of the audio
  final double height;
  final double? width;
  final double barBorderRadius;
  final double barSpacing;
  final EdgeInsets? margin;
  final double progress; // Parameter for audio progress
  final double minBarHeight; // New parameter for minimum height of the bars

  const AudioWaveBars({
    super.key,
    required this.amplitudes,
    this.barWidth = 2.0,
    this.barColor = Colors.white,
    this.barColorActive = Colors.blue, // Default color for active part
    this.backgroundColor = Colors.transparent,
    required this.height,
    this.width,
    this.barBorderRadius = 0.0,
    this.barSpacing = 0.0,
    this.margin,
    this.progress = 0.0, // Default progress
    this.minBarHeight = 2.0, // Default minimum height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      color: backgroundColor,
      margin: margin,
      alignment: Alignment.center,
      child: ClipRect(
        child: CustomPaint(
          size: Size.infinite,
          painter: AudioWaveBarsPainter(
            amplitudes,
            barWidth,
            barColor,
            barColorActive,
            barBorderRadius,
            barSpacing,
            progress, // Pass progress to the painter
            minBarHeight, // Pass minimum bar height to the painter
          ),
        ),
      ),
    );
  }
}

class AudioWaveBarsPainter extends CustomPainter {
  final List<double> amplitudes;
  final double barWidth;
  final Color barColor;
  final Color barColorActive; // Color for active part
  final double barBorderRadius;
  final double barSpacing;
  final double progress; // Progress parameter
  final double minBarHeight; // Minimum height of the bars

  AudioWaveBarsPainter(
    this.amplitudes,
    this.barWidth,
    this.barColor,
    this.barColorActive,
    this.barBorderRadius,
    this.barSpacing,
    this.progress,
    this.minBarHeight, // Receive minimum height
  );

  @override
  void paint(Canvas canvas, Size size) {
    final maxAmplitude =
        amplitudes.isNotEmpty ? amplitudes.reduce((a, b) => a > b ? a : b) : 1;
    final centerY = size.height / 2; // Center Y position

    for (int i = 0; i < amplitudes.length; i++) {
      final amplitude = amplitudes[i];
      final height =
          (amplitude / maxAmplitude) * centerY; // Adjust height calculation

      // Ensure the height respects the minimum bar height
      final barHeight = height < minBarHeight ? minBarHeight : height;

      // Draw the bar starting from center with border radius
      final rect = Rect.fromLTWH(
          (i * (barWidth + barSpacing)).toDouble(),
          centerY - barHeight,
          barWidth,
          barHeight * 2); // Double height for both directions
      final rRect =
          RRect.fromRectAndRadius(rect, Radius.circular(barBorderRadius));

      // Determine the color based on the progress
      final paint = Paint()
        ..color =
            (i / amplitudes.length <= progress) ? barColorActive : barColor
        ..style = PaintingStyle.fill;

      // Draw the rounded rectangle
      canvas.drawRRect(rRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
