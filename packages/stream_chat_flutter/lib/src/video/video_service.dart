import 'dart:async';

import 'package:flutter/services.dart';
import 'package:stream_thumbnail/stream_thumbnail.dart';

///
// ignore: prefer-match-file-name
class _IVideoService {
  _IVideoService._();

  /// Singleton instance of [_IVideoService]
  static final _IVideoService instance = _IVideoService._();

  /// Generates a thumbnail image data in memory as UInt8List.
  ///
  /// If no [source] is supplied, or if a thumbnail cannot be generated,
  /// returns [generatePlaceholderThumbnail]. A stock placeholder image.
  ///
  /// Use [timeMs] to pick the frame, and [maxHeight]/[maxWidth] to bound the
  /// size or `0` to keep the source resolution. A lower [quality] reduces
  /// image quality, but it gets ignored for PNG format.
  ///
  /// Windows has no WebP encoder, so [StreamThumbnailFormat.webp] fails there.
  Future<Uint8List?> generateVideoThumbnail({
    StreamThumbnailSource? source,
    StreamThumbnailFormat imageFormat = .png,
    int maxHeight = 0,
    int maxWidth = 0,
    int timeMs = 0,
    int quality = 10,
  }) async {
    // If the video source is not supplied, return a placeholder image.
    if (source == null) return generatePlaceholderThumbnail();

    try {
      return await StreamThumbnail.thumbnailData(
        source: source,
        imageFormat: imageFormat,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        timeMs: timeMs,
        quality: quality,
      );
    } catch (_) {
      // If the thumbnail generation fails, return a placeholder image.
      return generatePlaceholderThumbnail();
    }
  }

  /// Generates a placeholder thumbnail by loading placeholder.png from assets.
  Future<Uint8List> generatePlaceholderThumbnail() async {
    final placeholder = await rootBundle.load(
      'packages/stream_chat_flutter/lib/assets/images/placeholder.png',
    );

    return placeholder.buffer.asUint8List();
  }
}

/// Get instance of [_IVideoService]
// ignore: non_constant_identifier_names
_IVideoService get StreamVideoService => _IVideoService.instance;
