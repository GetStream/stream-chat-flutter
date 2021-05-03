import 'dart:async';
import 'dart:typed_data';

import 'package:synchronized/synchronized.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class IVideoService {
  static final IVideoService instance = IVideoService._();
  final _lock = Lock();

  IVideoService._();

  /// compress video from [path]
  /// compress video from [path] return [Future<MediaInfo>]
  ///
  /// you can choose its quality by [quality],
  /// determine whether to delete his source file by [deleteOrigin]
  /// optional parameters [startTime] [duration] [includeAudio] [frameRate]
  ///
  /// ## example
  /// ```dart
  /// final info = await _flutterVideoCompress.compressVideo(
  ///   file.path,
  ///   deleteOrigin: true,
  /// );
  /// debugPrint(info.toJson());
  /// ```
  Future<MediaInfo?> compressVideo(String? path) async {
    return _lock.synchronized(() {
      return VideoCompress.compressVideo(
        path!,
      );
    });
  }

  /// Generates a thumbnail image data in memory as UInt8List, it can be easily used by Image.memory(...).
  /// The video can be a local video file, or an URL repreents iOS or Android native supported video format.
  /// Speicify the maximum height or width for the thumbnail or 0 for same resolution as the original video.
  /// The lower quality value creates lower quality of the thumbnail image, but it gets ignored for PNG format.
  Future<Uint8List?> generateVideoThumbnail({
    required String video,
    ImageFormat imageFormat = ImageFormat.PNG,
    int maxHeight = 0,
    int maxWidth = 0,
    int timeMs = 0,
    int quality = 10,
  }) {
    return VideoThumbnail.thumbnailData(
      video: video,
      imageFormat: imageFormat,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      timeMs: timeMs,
      quality: quality,
    );
  }
}

// ignore: non_constant_identifier_names
IVideoService get VideoService => IVideoService.instance;
