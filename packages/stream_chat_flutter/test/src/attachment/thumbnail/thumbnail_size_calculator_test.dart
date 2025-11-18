// ignore_for_file: avoid_redundant_argument_values

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_size_calculator.dart';

void main() {
  group('ThumbnailSizeCalculator.calculate', () {
    group('returns null when', () {
      test('both target dimensions are infinite', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: Size.infinite,
          pixelRatio: 1,
        );

        expect(result, isNull);
      });

      test('original size is null', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: null,
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNull);
      });

      test('original size has zero width', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(0, 1080),
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNull);
      });

      test('original size has zero height', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 0),
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNull);
      });
    });

    group('with finite constraints', () {
      test('maintains aspect ratio when fitting wider image in container', () {
        // 16:9 image (1920x1080) fitting into 400x300 container
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // Should fit to width: 400x225 (maintains 16:9)
        expect(result!.width, closeTo(400, 0.01));
        expect(result.height, closeTo(225, 0.01));
      });

      test('maintains aspect ratio when fitting taller image in container', () {
        // 9:16 image (1080x1920) fitting into 400x300 container
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1080, 1920),
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // Should fit to height: 168.75x300 (maintains 9:16)
        expect(result!.width, closeTo(168.75, 0.01));
        expect(result.height, closeTo(300, 0.01));
      });

      test('applies pixel ratio correctly', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(400, 300),
          pixelRatio: 2,
        );

        expect(result, isNotNull);
        // 400x225 at 2x = 800x450
        expect(result!.width, closeTo(800, 0.01));
        expect(result.height, closeTo(450, 0.01));
      });

      test('handles 3x pixel ratio', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(400, 300),
          pixelRatio: 3,
        );

        expect(result, isNotNull);
        // 400x225 at 3x = 1200x675
        expect(result!.width, closeTo(1200, 0.01));
        expect(result.height, closeTo(675, 0.01));
      });

      test('handles square images', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1000, 1000),
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // Should fit to height: 300x300 (maintains 1:1)
        expect(result!.width, closeTo(300, 0.01));
        expect(result.height, closeTo(300, 0.01));
      });

      test('handles very wide panorama images', () {
        // 21:9 ultra-wide
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(2560, 1080),
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // Should fit to width
        expect(result!.width, closeTo(400, 0.01));
        expect(result.height, closeTo(168.75, 0.01));
      });

      test('handles very tall images', () {
        // Tall image like a mobile screenshot
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1080, 2340),
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // Should fit to height
        expect(result!.width, closeTo(138.46, 0.01));
        expect(result.height, closeTo(300, 0.01));
      });
    });

    group('with infinite width', () {
      test('calculates width from height maintaining aspect ratio', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(double.infinity, 300),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // 16:9 aspect ratio: width = 300 * (16/9) = 533.33
        expect(result!.width, closeTo(533.33, 0.01));
        expect(result.height, closeTo(300, 0.01));
      });

      test('applies pixel ratio after calculating width', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(double.infinity, 300),
          pixelRatio: 2,
        );

        expect(result, isNotNull);
        // 533.33x300 at 2x = 1066.66x600
        expect(result!.width, closeTo(1066.66, 0.01));
        expect(result.height, closeTo(600, 0.01));
      });
    });

    group('with infinite height', () {
      test('calculates height from width maintaining aspect ratio', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(400, double.infinity),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // 16:9 aspect ratio: height = 400 / (16/9) = 225
        expect(result!.width, closeTo(400, 0.01));
        expect(result.height, closeTo(225, 0.01));
      });

      test('applies pixel ratio after calculating height', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(400, double.infinity),
          pixelRatio: 2,
        );

        expect(result, isNotNull);
        // 400x225 at 2x = 800x450
        expect(result!.width, closeTo(800, 0.01));
        expect(result.height, closeTo(450, 0.01));
      });
    });

    group('edge cases', () {
      test('handles very small target sizes', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(10, 10),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // Should maintain aspect ratio even for tiny sizes
        expect(result!.width, closeTo(10, 0.01));
        expect(result.height, closeTo(5.625, 0.01));
      });

      test('handles very large target sizes', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(4000, 3000),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // Should still maintain aspect ratio for upscaling
        expect(result!.width, closeTo(4000, 0.01));
        expect(result.height, closeTo(2250, 0.01));
      });

      test('handles fractional pixel ratio', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(400, 300),
          pixelRatio: 1.5,
        );

        expect(result, isNotNull);
        // 400x225 at 1.5x = 600x337.5
        expect(result!.width, closeTo(600, 0.01));
        expect(result.height, closeTo(337.5, 0.01));
      });

      test('handles pixel ratio of 1.0', () {
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(1920, 1080),
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        expect(result!.width, closeTo(400, 0.01));
        expect(result.height, closeTo(225, 0.01));
      });

      test('handles original size smaller than target', () {
        // Small original image (100x100) being scaled up to 400x300
        final result = ThumbnailSizeCalculator.calculate(
          originalSize: const Size(100, 100),
          targetSize: const Size(400, 300),
          pixelRatio: 1,
        );

        expect(result, isNotNull);
        // Should still maintain aspect ratio (1:1)
        expect(result!.width, closeTo(300, 0.01));
        expect(result.height, closeTo(300, 0.01));
      });
    });
  });
}
