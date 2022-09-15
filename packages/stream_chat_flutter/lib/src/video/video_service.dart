import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/utils/device_segmentation.dart';
import 'package:thumblr/thumblr.dart' as thumblr;
import 'package:video_thumbnail/video_thumbnail.dart';

///
// ignore: prefer-match-file-name
class _IVideoService {
  _IVideoService._();

  /// Singleton instance of [_IVideoService]
  static final _IVideoService instance = _IVideoService._();

  /// Generates a thumbnail image data in memory as UInt8List.
  ///
  /// The video source can be a local video file or a URL.
  ///
  /// Thumbnails are not supported on Web at this time.
  ///
  /// For desktop, you can specify the position of the video to generate
  /// the thumbnail.
  ///
  /// For mobile, you can specify the maximum height or width for the thumbnail
  /// or 0 for same resolution as the original video. The lower quality value
  /// creates lower quality of the thumbnail image, but it gets ignored for
  /// PNG format.
  Future<Uint8List?> generateVideoThumbnail({
    required String video,
    ImageFormat imageFormat = ImageFormat.PNG,
    int maxHeight = 0,
    int maxWidth = 0,
    int timeMs = 0,
    int quality = 10,
  }) async {
    if (kIsWeb) {
      final placeholder = await generatePlaceholderThumbnail();
      return placeholder;
    }
    if (isDesktopDevice) {
      try {
        final thumbnail = await thumblr.generateThumbnail(filePath: video);
        final byteData = await thumbnail.image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        final bytesList = byteData?.buffer.asUint8List() ?? Uint8List(0);
        if (bytesList.isNotEmpty) {
          return bytesList;
        } else {
          return await generatePlaceholderThumbnail();
        }
      } catch (e) {
        // If the thumbnail generation fails, return a placeholder image.
        final placeholder = await generatePlaceholderThumbnail();
        return placeholder;
      }
    } else if (isMobileDevice) {
      return VideoThumbnail.thumbnailData(
        video: video,
        imageFormat: imageFormat,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        timeMs: timeMs,
        quality: quality,
      );
    }
    throw Exception('Could not generate thumbnail');
  }

  /// Generates a placeholder thumbnail by loading placeholder.png from assets.
  Future<Uint8List> generatePlaceholderThumbnail() async {
    final placeholder = await rootBundle
        .load('packages/stream_chat_flutter/images/placeholder.png');
    return placeholder.buffer.asUint8List();
  }
}

/// Get instance of [_IVideoService]
// ignore: non_constant_identifier_names
_IVideoService get StreamVideoService => _IVideoService.instance;
