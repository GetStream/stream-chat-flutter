import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/utils/jitter.dart';

void main() {
  group('Jitter', () {
    test('default constructor creates jitter with specified intensity', () {
      const intensity = 0.6;
      final jitter = Jitter(intensity: intensity);

      expect(jitter.intensity, equals(intensity));
    });

    test('default constructor clamps intensity to valid range', () {
      final jitterNegative = Jitter(intensity: -0.5);
      final jitterExcessive = Jitter(intensity: 2);

      expect(jitterNegative.intensity, equals(0.0));
      expect(jitterExcessive.intensity, equals(1.0));
    });

    test('default constructor uses deterministic seed when provided', () {
      const seed = 42;
      final jitter1 = Jitter(seed: seed, intensity: 0.5);
      final jitter2 = Jitter(seed: seed, intensity: 0.5);

      const point = Offset(10, 10);
      const maxDx = 5.0;
      const maxDy = 5.0;

      final result1 = jitter1.applyTo(point, maxDx, maxDy);
      final result2 = jitter2.applyTo(point, maxDx, maxDy);

      expect(result1, equals(result2));
    });

    test('custom constructor creates jitter with provided random instance', () {
      final random = Random(123);
      const intensity = 0.7;
      final jitter = Jitter.custom(random: random, intensity: intensity);

      expect(jitter.intensity, equals(intensity));
    });

    test('custom constructor clamps intensity to valid range', () {
      final random = Random();
      final jitterNegative = Jitter.custom(random: random, intensity: -1);
      final jitterExcessive = Jitter.custom(random: random, intensity: 3);

      expect(jitterNegative.intensity, equals(0.0));
      expect(jitterExcessive.intensity, equals(1.0));
    });

    group('factory constructors', () {
      test('none creates jitter with zero intensity', () {
        final jitter = Jitter.none();
        expect(jitter.intensity, equals(0.0));
      });

      test('light creates jitter with 0.2 intensity', () {
        final jitter = Jitter.light();
        expect(jitter.intensity, equals(0.2));
      });

      test('medium creates jitter with 0.4 intensity', () {
        final jitter = Jitter.medium();
        expect(jitter.intensity, equals(0.4));
      });

      test('heavy creates jitter with 0.6 intensity', () {
        final jitter = Jitter.heavy();
        expect(jitter.intensity, equals(0.6));
      });

      test('max creates jitter with 1.0 intensity', () {
        final jitter = Jitter.max();
        expect(jitter.intensity, equals(1.0));
      });

      test('factory constructors use deterministic seed when provided', () {
        const seed = 999;
        final jitter1 = Jitter.light(seed: seed);
        final jitter2 = Jitter.light(seed: seed);

        const point = Offset(20, 30);
        const maxDx = 10.0;
        const maxDy = 15.0;

        final result1 = jitter1.applyTo(point, maxDx, maxDy);
        final result2 = jitter2.applyTo(point, maxDx, maxDy);

        expect(result1, equals(result2));
      });
    });

    group('applyTo', () {
      test('returns original point when intensity is zero', () {
        final jitter = Jitter.none();
        const point = Offset(5, 10);

        final result = jitter.applyTo(point, 20, 30);

        expect(result, equals(point));
      });

      test('applies displacement when intensity is greater than zero', () {
        final jitter = Jitter.medium(seed: 42);
        const point = Offset(100, 200);

        final result = jitter.applyTo(point, 50, 100);

        expect(result, isNot(equals(point)));
      });

      test('displacement is within expected bounds', () {
        final jitter = Jitter.max(seed: 123);
        const point = Offset(50, 50);
        const maxDx = 20.0;
        const maxDy = 30.0;

        final result = jitter.applyTo(point, maxDx, maxDy);

        // With max intensity (1), displacement should be within [-maxDx, maxDx]
        expect(result.dx, greaterThanOrEqualTo(point.dx - maxDx));
        expect(result.dx, lessThanOrEqualTo(point.dx + maxDx));
        expect(result.dy, greaterThanOrEqualTo(point.dy - maxDy));
        expect(result.dy, lessThanOrEqualTo(point.dy + maxDy));
      });

      test('produces consistent results with same seed', () {
        const seed = 456;
        final jitter1 = Jitter(seed: seed, intensity: 0.8);
        final jitter2 = Jitter(seed: seed, intensity: 0.8);

        const point = Offset(15, 25);
        const maxDx = 8.0;
        const maxDy = 12.0;

        final result1 = jitter1.applyTo(point, maxDx, maxDy);
        final result2 = jitter2.applyTo(point, maxDx, maxDy);

        expect(result1, equals(result2));
      });

      test('produces different results with different seeds', () {
        final jitter1 = Jitter(seed: 111, intensity: 0.5);
        final jitter2 = Jitter(seed: 222, intensity: 0.5);

        const point = Offset(40, 60);
        const maxDx = 15.0;
        const maxDy = 20.0;

        final result1 = jitter1.applyTo(point, maxDx, maxDy);
        final result2 = jitter2.applyTo(point, maxDx, maxDy);

        expect(result1, isNot(equals(result2)));
      });

      test('intensity affects displacement magnitude', () {
        const seed = 789;
        final lightJitter = Jitter(seed: seed, intensity: 0.1);
        final heavyJitter = Jitter(seed: seed, intensity: 0.9);

        const point = Offset(100, 100);
        const maxDx = 50.0;
        const maxDy = 50.0;

        final lightResult = lightJitter.applyTo(point, maxDx, maxDy);
        final heavyResult = heavyJitter.applyTo(point, maxDx, maxDy);

        final lightDistance = (lightResult - point).distance;
        final heavyDistance = (heavyResult - point).distance;

        // Heavy jitter should generally produce larger displacement
        // Note: This is probabilistic, but with the same seed the pattern holds
        expect(heavyDistance, greaterThan(lightDistance));
      });

      test('handles edge cases gracefully', () {
        final jitter = Jitter.medium();

        // Test with zero bounds
        final resultZero = jitter.applyTo(const Offset(10, 10), 0, 0);
        expect(resultZero, equals(const Offset(10, 10)));

        // Test with negative point coordinates
        final resultNegative = jitter.applyTo(const Offset(-5, -8), 10, 15);
        expect(resultNegative, isA<Offset>());
      });
    });
  });
}
