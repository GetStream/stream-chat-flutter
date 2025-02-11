import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/audio/audio_sampling.dart';

void main() {
  group('resampleWaveformData', () {
    test('returns original data when target size equals input size', () {
      final input = [1.0, 2.0, 3.0, 4.0];
      expect(resampleWaveformData(input, 4), equals(input));
    });

    test('downsamples when target size is smaller', () {
      final input = List.generate(10, (i) => i.toDouble());
      final result = resampleWaveformData(input, 5);
      expect(result.length, equals(5));
      // First and last points should be preserved
      expect(result.first, equals(input.first));
      expect(result.last, equals(input.last));
    });

    test('upsamples when target size is larger', () {
      final input = [1.0, 2.0, 3.0];
      final result = resampleWaveformData(input, 6);
      expect(result.length, equals(6));
      // Check if values are repeated appropriately
      expect(result.where((x) => x == 1.0).length, equals(2));
      expect(result.where((x) => x == 2.0).length, equals(2));
      expect(result.where((x) => x == 3.0).length, equals(2));
    });
  });

  group('downSample', () {
    test('handles single point target size', () {
      final input = [1.0, 2.0, 3.0, 4.0];
      final result = downSample(input, 1);
      expect(result.length, equals(1));
      expect(result[0], equals(2.5)); // Mean of all values
    });

    test('preserves first and last points', () {
      final input = List.generate(100, (i) => i.toDouble());
      final result = downSample(input, 10);
      expect(result.first, equals(input.first));
      expect(result.last, equals(input.last));
      expect(result.length, equals(10));
    });

    test('returns original data when target size is larger', () {
      final input = [1.0, 2.0, 3.0];
      expect(downSample(input, 5), equals(input));
    });

    test('handles empty input', () {
      expect(downSample([], 5), isEmpty);
    });
  });

  group('upSample', () {
    test('handles empty input', () {
      expect(upSample([], 5), equals([0.0, 0.0, 0.0, 0.0, 0.0]));
    });

    test('maintains original values when target size equals input size', () {
      final input = [1.0, 2.0, 3.0];
      expect(upSample(input, 3), equals(input));
    });

    test('correctly distributes remainder', () {
      final input = [1.0, 2.0, 3.0];
      final result = upSample(input, 7);
      expect(result.length, equals(7));
      // Check if the remainder is distributed correctly
      final countMap = <double, int>{};
      for (final value in result) {
        countMap[value] = (countMap[value] ?? 0) + 1;
      }
      // Each value should appear either 2 or 3 times
      expect(
          countMap.values.every((count) => count == 2 || count == 3), isTrue);
    });

    test('returns original data when target size is smaller', () {
      final input = [1.0, 2.0, 3.0, 4.0];
      expect(upSample(input, 2), equals(input));
    });
  });

  group('edge cases', () {
    test('handles negative values', () {
      final input = [-1.0, -2.0, -3.0, -4.0];
      final result = resampleWaveformData(input, 2);
      expect(result.length, equals(2));
      expect(result.every((x) => x < 0), isTrue);
    });

    test('handles repeated values', () {
      final input = [1.0, 1.0, 1.0, 1.0];
      final result = resampleWaveformData(input, 2);
      expect(result.length, equals(2));
      expect(result.every((x) => x == 1.0), isTrue);
    });

    test('handles very large numbers', () {
      final input = List.generate(5, (i) => pow(10, i).toDouble());
      final result = resampleWaveformData(input, 3);
      expect(result.length, equals(3));
      expect(result.first, equals(input.first));
      expect(result.last, equals(input.last));
    });

    test('handles very small numbers', () {
      final input = List.generate(5, (i) => pow(0.1, i).toDouble());
      final result = resampleWaveformData(input, 3);
      expect(result.length, equals(3));
      expect(result.first, equals(input.first));
      expect(result.last, equals(input.last));
    });
  });
}
