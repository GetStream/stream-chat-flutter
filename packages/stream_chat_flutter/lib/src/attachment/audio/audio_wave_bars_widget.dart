import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

const _amplitudeInterval = 100;
const _maxBars = 70;

/// Docs
class AudioWaveBars extends StatefulWidget {
  /// Docs
  const AudioWaveBars({
    super.key,
    required this.amplitudeStream,
  });

  /// Docs
  final Stream<Amplitude> amplitudeStream;

  @override
  State<AudioWaveBars> createState() => _AudioWaveBarsState();
}

class _AudioWaveBarsState extends State<AudioWaveBars> {
  final barsQueue = QueueList<double>(_maxBars);
  late Stream<List<double>> barsStream;

  @override
  void initState() {
    super.initState();

    barsStream = widget.amplitudeStream.map((amplitude) {
      if (barsQueue.length == _maxBars) {
        barsQueue.removeLast();
      }

      barsQueue.addFirst((amplitude.current + 70) / 70);
      return barsQueue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Todo: Evaluate if I should extract this to a controller class.

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return StreamBuilder<List<double>>(
          initialData: List.empty(),
          stream: barsStream.asBroadcastStream(),
          builder: (context, snapshot) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _AudioBarsPainter(
                bars: snapshot.data ?? List.empty(),
                inverse: true,
              ),
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
    this.numberOfBars = _maxBars,
    this.colorLeft = Colors.blueAccent,
    this.colorRight = Colors.grey,
    this.barHeightRatio = 1,
    this.spacingRatio = 0.005,
    this.inverse = false,
  });

  final List<double> bars;
  final int numberOfBars;
  final Color colorRight;
  final Color colorLeft;
  final double barHeightRatio;
  final double spacingRatio;
  final bool inverse;

  double _barHeight(double barValue, totalHeight) {
    return max(barValue * totalHeight * barHeightRatio, 2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final totalWidth = size.width;
    final spacingWidth = totalWidth * spacingRatio;
    final totalBarWidth = totalWidth - spacingWidth * (numberOfBars - 1);
    final barWidth = totalBarWidth / numberOfBars;
    final barY = size.height / 2;
    final List<double> dataBars;
    var hasRemainingBars = false;

    void drawBar(int i, double barValue, Color color) {
      final barHeight = _barHeight(barValue, size.height);
      final barX = inverse
          ? totalWidth - i * (barWidth + spacingWidth) + barWidth / 2
          : i * (barWidth + spacingWidth) + barWidth / 2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(barX, barY),
          width: barWidth,
          height: barHeight,
        ),
        const Radius.circular(50),
      );

      final paint = Paint()..color = color;
      canvas.drawRRect(rect, paint);
    }

    if (bars.length > numberOfBars) {
      /// Misconfiguration, bars.length should never be bigger
      /// than numberOfBars.
      dataBars = bars.take(numberOfBars).toList();
    } else {
      hasRemainingBars = numberOfBars > bars.length;
      dataBars = bars;
    }

    // Drawing bars with real data
    dataBars.forEachIndexed((i, bar) => drawBar(i, bar, colorLeft));

    // Drawing remaining bars
    if (hasRemainingBars) {
      for (var i = bars.length - 1; i < numberOfBars; i++) {
        drawBar(i, 0, colorRight);
      }
    }
  }

  //Todo: Take a look in this method later.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
