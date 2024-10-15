import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/custom_theme/unikon_theme.dart';

class AudioWaveBars extends StatelessWidget {
  final List<double> amplitudes;
  final double barWidth;
  final Color barColor;
  final Color backgroundColor;
  final Color barColorActive;
  final double height;
  final double? width;
  final double barBorderRadius;
  final double barSpacing;
  final EdgeInsets? margin;
  final double progress;
  final double minBarHeight;
  final double visiblePercentage; // New parameter to control visible percentage

  const AudioWaveBars({
    super.key,
    required this.amplitudes,
    this.barWidth = 2.0,
    this.barColor = Colors.white,
    this.barColorActive = Colors.white,
    this.backgroundColor = UnikonColorTheme.transparent,
    required this.height,
    this.width,
    this.barBorderRadius = 0.0,
    this.barSpacing = 0.0,
    this.margin,
    required this.progress,
    this.minBarHeight = 2.0,
    this.visiblePercentage = 40.0, // Default 40% visible
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = width ?? constraints.maxWidth;

        return Container(
          width: containerWidth,
          height: height,
          color: backgroundColor,
          margin: margin,
          alignment: Alignment.center,
          child: CustomPaint(
            size: Size(containerWidth, height),
            painter: AudioWaveBarsPainter(
              amplitudes: amplitudes,
              barWidth: barWidth,
              barColor: barColor,
              barColorActive: barColorActive,
              barBorderRadius: barBorderRadius,
              barSpacing: barSpacing,
              progress: progress,
              minBarHeight: minBarHeight,
              visiblePercentage: visiblePercentage, // Pass the percentage
            ),
          ),
        );
      },
    );
  }
}

class AudioWaveBarsPainter extends CustomPainter {
  final List<double> amplitudes;
  final double barWidth;
  final Color barColor;
  final Color barColorActive;
  final double barBorderRadius;
  final double barSpacing;
  final double progress;
  final double minBarHeight;
  final double visiblePercentage; // New parameter

  AudioWaveBarsPainter({
    required this.amplitudes,
    required this.barWidth,
    required this.barColor,
    required this.barColorActive,
    required this.barBorderRadius,
    required this.barSpacing,
    required this.progress,
    required this.minBarHeight,
    required this.visiblePercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxAmplitude = amplitudes.isNotEmpty ? amplitudes.reduce(max) : 1;
    final centerY = size.height / 2;

    final visibleBarsCount = (size.width / (barWidth + barSpacing)).floor();

    // Calculate the range based on the progress
    double visibleRangeStart = (progress * (100 - visiblePercentage))
        .clamp(0.0, 100 - visiblePercentage);
    double visibleRangeEnd = visibleRangeStart + visiblePercentage;

    // Convert range from percentage to the actual range in amplitudes
    int startIndex = (visibleRangeStart / 100 * amplitudes.length).floor();
    int endIndex = (visibleRangeEnd / 100 * amplitudes.length).floor();

    // Loop through visible range and draw bars
    for (int i = startIndex; i < endIndex; i++) {
      final amplitude = amplitudes[i];
      final height = (amplitude / maxAmplitude) * centerY;
      final barHeight = height < minBarHeight ? minBarHeight : height;

      final xOffset = (i - startIndex) * (barWidth + barSpacing);
      final rect = Rect.fromLTWH(
          xOffset.toDouble(), centerY - barHeight, barWidth, barHeight * 2);

      final rRect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(barBorderRadius),
      );

      // Calculate the color based on the progress
      double t = (i - startIndex) / (endIndex - startIndex).toDouble();
      final currentBarColor = Color.lerp(
        barColor,
        barColorActive,
        t,
      )!;

      final paint = Paint()
        ..color = currentBarColor
        ..style = PaintingStyle.fill;

      // Draw the bar
      canvas.drawRRect(rRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant AudioWaveBarsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.amplitudes != amplitudes ||
        oldDelegate.visiblePercentage != visiblePercentage;
  }
}
