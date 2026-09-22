import 'dart:ui';

/// Utility class for calculating optimal thumbnail sizes for image
/// attachments.
///
/// This calculator ensures that images are decoded and cached at
/// appropriate sizes based on display constraints, maintaining aspect
/// ratio while accounting for device pixel density.
class ThumbnailSizeCalculator {
  ThumbnailSizeCalculator._();

  /// Calculates the optimal thumbnail size for an image attachment.
  ///
  /// Returns `null` if:
  /// - Both [targetSize] dimensions are infinite
  /// - [originalSize] is not available (needed for aspect ratio)
  ///
  /// The calculation:
  /// 1. Handles infinite constraints by calculating from the finite
  ///    dimension
  /// 2. Maintains aspect ratio to prevent image distortion
  /// 3. Applies [pixelRatio] for device-appropriate resolution
  /// 4. Caps the result at [originalSize], so the image is never upscaled
  ///
  /// Example:
  /// ```dart
  /// final size = ThumbnailSizeCalculator.calculate(
  ///   originalSize: Size(1920, 1080),
  ///   targetSize: Size(400, 300),
  ///   pixelRatio: 2.0,
  /// );
  /// // Returns: Size(800, 450) - maintains 16:9 aspect ratio,
  /// // scaled for 2x display
  /// ```
  static Size? calculate({
    Size? originalSize,
    required Size targetSize,
    required double pixelRatio,
  }) {
    final original = originalSize;
    if (original == null) return null;

    final originalAspectRatio = original.aspectRatio;
    // Invalid aspect ratio indicates invalid original size
    if (originalAspectRatio.isInfinite || originalAspectRatio <= 0) {
      return null;
    }

    var thumbnailWidth = targetSize.width;
    var thumbnailHeight = targetSize.height;

    // Cannot calculate optimal size with infinite constraints
    if (thumbnailWidth.isInfinite && thumbnailHeight.isInfinite) {
      return null;
    }

    if (thumbnailWidth.isInfinite) {
      // Width is infinite, calculate from height
      thumbnailWidth = thumbnailHeight * originalAspectRatio;
    }
    if (thumbnailHeight.isInfinite) {
      // Height is infinite, calculate from width
      thumbnailHeight = thumbnailWidth / originalAspectRatio;
    }

    // Calculate size that maintains aspect ratio within constraints
    final targetAspectRatio = thumbnailWidth / thumbnailHeight;
    if (originalAspectRatio > targetAspectRatio) {
      // Image is wider than container - fit to width
      thumbnailHeight = thumbnailWidth / originalAspectRatio;
    } else {
      // Image is taller than container - fit to height
      thumbnailWidth = thumbnailHeight * originalAspectRatio;
    }

    // Apply pixel ratio to get physical pixel dimensions
    final width = thumbnailWidth * pixelRatio;
    final height = thumbnailHeight * pixelRatio;

    // Asking for more than the source holds costs bytes for pixels it does
    // not have.
    if (width >= original.width || height >= original.height) return original;

    return Size(width, height);
  }
}
