import 'dart:async';

import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/attachment/audio/list_normalization.dart';

/// Docs
class WaveBarsNormalizer {
  /// Docs
  WaveBarsNormalizer({
    required this.barsStream,
    this.barVariation = 70,
    this.outputSize = 50,
  });
  /// Docs
  final Stream<Amplitude> barsStream;
  /// Docs
  final double barVariation;
  /// Docs
  final int outputSize;
  /// Docs
  StreamSubscription<double>? _barsSubscription;
  /// Docs
  List<double>? _barsList;

  /// Docs
  void start() {
    _barsList = List.filled(outputSize, 0);

    _barsSubscription = barsStream.map((amplitude) {
      final barValue = amplitude.current;
      return (barValue + barVariation) / barVariation;
    }).listen((barPercentage) {
      _barsList?.add(barPercentage);
    });
  }

  /// Docs
  List<double> normalizedBars() {
    if (_barsList == null) return List.empty();

    return ListNormalization.normalizeList(_barsList!, outputSize);
  }

  /// Docs
  void dispose() {
    _barsSubscription?.cancel();
  }
}
