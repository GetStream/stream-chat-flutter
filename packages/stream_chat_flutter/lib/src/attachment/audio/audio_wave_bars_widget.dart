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
    required this.recorder,
    required this.recordState,
  });

  /// Docs
  final Record recorder;

  /// Docs
  final Stream<RecordState> recordState;

  @override
  State<AudioWaveBars> createState() => _AudioWaveBarsState();
}

class _AudioWaveBarsState extends State<AudioWaveBars> {
  StreamSubscription<Amplitude>? _noiseSubscription;
  final barsQueue = QueueList<double>(_maxBars);
  late Stream<List<double>> amplitudeStream;

  @override
  void initState() {
    super.initState();

    const duration = Duration(milliseconds: _amplitudeInterval);
    amplitudeStream = widget.recorder.onAmplitudeChanged(duration).map((event) {
      if (barsQueue.length == _maxBars) {
        barsQueue.removeLast();
      }

      barsQueue.addFirst(event.current);
      return barsQueue;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _noiseSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // Todo: Evaluate if I should extract this to a controller class.

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return StreamBuilder<List<double>>(
          initialData: List<double>.filled(_maxBars, 0),
          stream: amplitudeStream,
          builder: (context, snapshot) {
            return CustomPaint(
              size: Size(constraints.maxWidth, 25),
              painter: _AudioBarsPainter(
                bars: snapshot.data ?? List<double>.filled(_maxBars, 0),
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
  });

  final List<double> bars;
  final int numberOfBars;
  final Color colorRight;
  final Color colorLeft;
  final double barHeightRatio;
  final double spacingRatio;

  double _barHeight(double barValue, totalHeight) {
    return max(barValue / 60 * totalHeight * barHeightRatio, 2);
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

    print('numberOfBars : $numberOfBars. bars.length: ${bars.length}');

    void drawBar(int i, double barValue, Color color) {
      final barHeight = _barHeight(barValue, size.height);
      final barX = i * (barWidth + spacingWidth) + barWidth / 2;

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
    dataBars.forEachIndexed((i, bar) => drawBar(i, bar.abs(), colorLeft));

    // Drawing remaining bars
    if (hasRemainingBars) {
      for (var i = bars.length - 1; i < numberOfBars; i++) {
        drawBar(i, 60, colorRight);
      }
    }
  }

  //Todo: Take a look in this method later.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
