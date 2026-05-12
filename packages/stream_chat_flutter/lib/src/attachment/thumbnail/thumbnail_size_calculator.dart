import 'package:flutter/rendering.dart';

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
  /// 2. Applies [fit] semantics to determine sizing behavior
  /// 3. Applies [pixelRatio] for device-appropriate resolution
  ///
  /// The [fit] parameter controls how the image is sized within
  /// [targetSize]. When null (the default), [BoxFit.scaleDown] is used —
  /// the same fallback Flutter's painter (`paintImage`) applies when an
  /// `Image` widget is rendered without an explicit fit.
  ///
  /// - [BoxFit.contain]: Scales to fit within the box while preserving
  ///   aspect ratio. The result will be no larger than the target in
  ///   either dimension.
  /// - [BoxFit.cover]: Scales to cover the entire box while preserving
  ///   aspect ratio. The result will be at least as large as the target
  ///   in both dimensions (one dimension may exceed it).
  /// - [BoxFit.fill]: Stretches to fill the box exactly, ignoring
  ///   aspect ratio.
  /// - [BoxFit.fitWidth]: Scales so the width matches the target width;
  ///   height is derived from the original aspect ratio.
  /// - [BoxFit.fitHeight]: Scales so the height matches the target
  ///   height; width is derived from the original aspect ratio.
  /// - [BoxFit.none]: Uses the original size without scaling, clamped
  ///   to the target dimensions.
  /// - [BoxFit.scaleDown] (default when [fit] is null): Same as
  ///   [BoxFit.contain] if the original is larger than the target;
  ///   otherwise [BoxFit.none].
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
    BoxFit? fit,
  }) {
    // If original size is not available, skip optimization.
    // We need the aspect ratio to avoid incorrect cropping.
    if (originalSize == null) return null;
    final originalAspectRatio = originalSize.aspectRatio;

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
    } else if (thumbnailHeight.isInfinite) {
      // Height is infinite, calculate from width
      thumbnailHeight = thumbnailWidth / originalAspectRatio;
    }

    final resolved = _applyFit(
      // Match Flutter's paintImage default when fit isn't specified.
      fit: fit ?? BoxFit.scaleDown,
      originalSize: originalSize,
      originalAspectRatio: originalAspectRatio,
      boxWidth: thumbnailWidth,
      boxHeight: thumbnailHeight,
    );

    // Apply pixel ratio to get physical pixel dimensions
    return resolved * pixelRatio;
  }

  static Size _applyFit({
    required BoxFit fit,
    required Size originalSize,
    required double originalAspectRatio,
    required double boxWidth,
    required double boxHeight,
  }) {
    return switch (fit) {
      // Stretch to fill exactly; aspect ratio not preserved.
      .fill => Size(boxWidth, boxHeight),

      // Match width, derive height from aspect ratio.
      .fitWidth => Size(boxWidth, boxWidth / originalAspectRatio),

      // Match height, derive width from aspect ratio.
      .fitHeight => Size(boxHeight * originalAspectRatio, boxHeight),

      // Use original size, clamped so we never decode larger than the
      // target box (decoding bigger than the box wastes memory).
      .none => Size(
        originalSize.width.clamp(0.0, boxWidth),
        originalSize.height.clamp(0.0, boxHeight),
      ),

      // Behaves like contain when the original would overflow,
      // otherwise returns the original size.
      .scaleDown => _scaleDown(
        originalSize: originalSize,
        originalAspectRatio: originalAspectRatio,
        boxWidth: boxWidth,
        boxHeight: boxHeight,
      ),

      // Largest size that covers the box while preserving aspect ratio.
      .cover => _cover(
        originalAspectRatio: originalAspectRatio,
        boxWidth: boxWidth,
        boxHeight: boxHeight,
      ),

      // Default: largest size that fits inside the box while preserving aspect ratio.
      .contain => _contain(
        originalAspectRatio: originalAspectRatio,
        boxWidth: boxWidth,
        boxHeight: boxHeight,
      ),
    };
  }

  // Largest size that fits inside the box while preserving aspect ratio.
  static Size _contain({
    required double originalAspectRatio,
    required double boxWidth,
    required double boxHeight,
  }) {
    final boxAspectRatio = boxWidth / boxHeight;
    if (originalAspectRatio > boxAspectRatio) {
      // Image is wider than the box — fit to width.
      return Size(boxWidth, boxWidth / originalAspectRatio);
    } else {
      // Image is taller than the box — fit to height.
      return Size(boxHeight * originalAspectRatio, boxHeight);
    }
  }

  // Original size if it already fits inside the box, otherwise the
  // largest size that fits inside the box while preserving aspect ratio.
  static Size _scaleDown({
    required Size originalSize,
    required double originalAspectRatio,
    required double boxWidth,
    required double boxHeight,
  }) {
    final containSize = _contain(
      originalAspectRatio: originalAspectRatio,
      boxWidth: boxWidth,
      boxHeight: boxHeight,
    );
    if (originalSize.width <= containSize.width && originalSize.height <= containSize.height) {
      return originalSize;
    }
    return containSize;
  }

  // Smallest size that covers the box while preserving aspect ratio.
  //
  // One dimension will match the box; the other will be larger.
  // We cap the decoded size at the cover dimensions — anything larger
  // would be cropped by the painter and just waste memory.
  static Size _cover({
    required double originalAspectRatio,
    required double boxWidth,
    required double boxHeight,
  }) {
    final boxAspectRatio = boxWidth / boxHeight;
    if (originalAspectRatio < boxAspectRatio) {
      // Image is taller than the box — match width, overflow height.
      return Size(boxWidth, boxWidth / originalAspectRatio);
    } else {
      // Image is wider than the box — match height, overflow width.
      return Size(boxHeight * originalAspectRatio, boxHeight);
    }
  }
}
