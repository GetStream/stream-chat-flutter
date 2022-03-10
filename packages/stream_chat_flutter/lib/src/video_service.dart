import 'dart:async';
import 'dart:typed_data';

import 'package:synchronized/synchronized.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

///
// ignore: prefer-match-file-name
class _IVideoService {
  _IVideoService._();

  /// Singleton instance of [_IVideoService]
  static final _IVideoService instance = _IVideoService._();
  final _lock = Lock();

  /// compress video from [path]
  /// compress video from [path] return [Future<MediaInfo>]
  ///
  /// you can choose its [quality] and [frameRate]
  ///
  /// ## example
  /// ```dart
  /// final info = await _flutterVideoCompress.compressVideo(
  ///   file.path,
  /// );
  /// debugPrint(info.toJson());
  /// ```
  Future<MediaInfo?> compressVideo(
    String path, {
    int frameRate = 30,
    VideoQuality quality = VideoQuality.DefaultQuality,
  }) async =>
      _lock.synchronized(
        () => VideoCompress.compressVideo(
          path,
          frameRate: frameRate,
          quality: quality,
        ),
      );

  /// Generates a thumbnail image data in memory as UInt8List,
  /// it can be easily used by Image.memory(...).
  /// The video can be a local video file, or an URL repreents iOS or
  /// Android native supported video format.
  /// Speicify the maximum height or width for the thumbnail or 0 for
  /// same resolution as the original video.
  /// The lower quality value creates lower quality of the thumbnail image,
  /// but it gets ignored for PNG format.
  Future<Uint8List?> generateVideoThumbnail({
    required String video,
    ImageFormat imageFormat = ImageFormat.PNG,
    int maxHeight = 0,
    int maxWidth = 0,
    int timeMs = 0,
    int quality = 10,
  }) =>
      VideoThumbnail.thumbnailData(
        video: video,
        imageFormat: imageFormat,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        timeMs: timeMs,
        quality: quality,
      );
}

/// Get instance of [_IVideoService]
@Deprecated("Use 'StreamVideoService' instead")
// ignore: non_constant_identifier_names
_IVideoService get VideoService => _IVideoService.instance;

/// Get instance of [_IVideoService]
// ignore: non_constant_identifier_names
_IVideoService get StreamVideoService => _IVideoService.instance;
