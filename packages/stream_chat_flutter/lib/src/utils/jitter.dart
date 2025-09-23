// ignore_for_file: avoid_redundant_argument_values

import 'dart:math';
import 'dart:ui';

/// Configuration for applying random displacement to polygon grid points.
///
/// Manages random displacement generation with a specified intensity level
/// using a seeded [Random] instance for deterministic jitter patterns. The
/// jitter creates visual variety in polygon backgrounds while maintaining
/// consistency for the same seed.
///
/// Example usage:
/// ```dart
/// final jitter = Jitter.medium(seed: userId.hashCode);
/// final jitteredPoint = jitter.applyTo(point, maxDx, maxDy);
/// ```
class Jitter {
  /// Creates a jitter configuration with the specified [intensity] and
  /// optional [seed].
  ///
  /// The [intensity] is automatically clamped to the range 0.0 to 1.0. When
  /// [seed] is null, uses a random seed for non-deterministic behavior.
  factory Jitter({int? seed, double intensity = 0.4}) {
    return Jitter.custom(
      random: Random(seed),
      intensity: intensity,
    );
  }

  /// Creates a jitter configuration with a custom [random] instance and
  /// [intensity].
  ///
  /// The [intensity] is automatically clamped to the range 0.0 to 1.0. This
  /// factory allows reusing an existing [Random] instance for performance.
  factory Jitter.custom({
    required Random random,
    double intensity = 0.4,
  }) {
    final clampedIntensity = intensity.clamp(0.0, 1.0);
    return Jitter._(random, clampedIntensity);
  }

  /// Creates a jitter configuration with no displacement (regular grid).
  factory Jitter.none({int? seed}) => Jitter(intensity: 0, seed: seed);

  /// Creates a jitter configuration with light displacement.
  factory Jitter.light({int? seed}) => Jitter(intensity: 0.2, seed: seed);

  /// Creates a jitter configuration with medium displacement.
  factory Jitter.medium({int? seed}) => Jitter(intensity: 0.4, seed: seed);

  /// Creates a jitter configuration with heavy displacement.
  factory Jitter.heavy({int? seed}) => Jitter(intensity: 0.6, seed: seed);

  /// Creates a jitter configuration with maximum displacement.
  factory Jitter.max({int? seed}) => Jitter(intensity: 1, seed: seed);

  // Creates a jitter configuration with the specified [_random] and [intensity]
  Jitter._(this._random, this.intensity);

  // The random number generator used for displacement calculations.
  final Random _random;

  /// The intensity of jitter displacement applied to points.
  ///
  /// Ranges from 0.0 (no displacement) to 1.0 (maximum displacement).
  final double intensity;

  /// Applies jitter displacement to the given [point] within the specified
  /// bounds.
  ///
  /// Returns the original [point] when [intensity] is 0. Otherwise, applies
  /// random displacement within the bounds defined by [maxDx] and [maxDy],
  /// scaled by the [intensity] value.
  ///
  /// The displacement is bidirectional (positive or negative) and uses the
  /// internal [Random] instance for consistent results across multiple calls.
  Offset applyTo(Offset point, double maxDx, double maxDy) {
    if (intensity <= 0) return point;

    final dx = (_random.nextDouble() * 2 - 1) * maxDx * intensity;
    final dy = (_random.nextDouble() * 2 - 1) * maxDy * intensity;
    return Offset(point.dx + dx, point.dy + dy);
  }
}
