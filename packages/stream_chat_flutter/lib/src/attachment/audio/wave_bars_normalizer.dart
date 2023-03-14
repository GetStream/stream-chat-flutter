import 'dart:async';
import 'dart:math';

import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/attachment/audio/list_normalization.dart';

/// Docs
class WaveBarsNormalizer {
  /// Docs
  WaveBarsNormalizer({
    required this.barsStream,
  });

  /// Docs
  final Stream<Amplitude> barsStream;

  /// Docs
  StreamSubscription<double>? _barsSubscription;

  /// Docs
  final List<double> _barsList = List<double>.empty(growable: true);

  double _minValue = 0;
  double _maxValue = 0;

  /// Docs
  void start() {
    _barsSubscription = barsStream
        .where((amplitude) => amplitude.current > -1000)
        .map((amplitude) {
      return amplitude.current;
    }).listen((barValue) {
      _maxValue = max(_maxValue, barValue);
      _minValue = min(_minValue, barValue);
      _barsList.add(barValue);
    });
  }

  /// Docs
  List<double> normalizedBars(int outputLength) {
    return ListNormalization.normalizeBars(_barsList, outputLength, _minValue);
  }

  /// Docs
  void reset() {
    _barsList.clear();
  }

  /// Docs
  void dispose() {
    _barsSubscription?.cancel();
  }
}
