import 'dart:async';
import 'dart:math';

import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/attachment/audio/list_normalization.dart';

/// {@template WaveBarsNormalizer}
/// This class holds the value bars to later provide the normalized bars.
/// The values should be provided by the barsStream and they will be kept until
/// needed.
/// {@endtemplate}
class WaveBarsNormalizer {
  /// {@macro WaveBarsNormalizer}
  WaveBarsNormalizer({required this.barsStream});

  /// The stream of amplitude of audio recorded.
  final Stream<Amplitude> barsStream;

  StreamSubscription<double>? _barsSubscription;
  final List<double> _barsList = List<double>.empty(growable: true);

  double _minValue = 0;

  /// Start listening to amplitude of the recoded sounds.
  void start() {
    _barsSubscription = barsStream
        .where((amplitude) => amplitude.current > -1000)
        .map((amplitude) {
      return amplitude.current;
    }).listen((barValue) {
      _minValue = min(_minValue, barValue);
      _barsList.add(barValue);
    });
  }

  /// Provides the normalized bars.
  List<double> normalizedBars(int outputLength) {
    return ListNormalization.normalizeBars(_barsList, outputLength, _minValue);
  }

  /// Clear the state of this class. Use this after calling normalizedBars to
  /// avoid using too much memory and causing memory overflow.
  void reset() {
    _minValue = 0;
    _barsList.clear();
  }

  /// Disposes the class.
  void dispose() {
    _minValue = 0;
    _barsList.clear();
    _barsSubscription?.cancel();
  }
}
