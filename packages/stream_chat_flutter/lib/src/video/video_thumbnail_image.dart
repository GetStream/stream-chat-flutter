import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/video/video_service.dart';
import 'package:video_thumbnail/video_thumbnail.dart' show ImageFormat;

/// {@template video_thumbnail_image}
/// A custom [ImageProvider] class for loading video thumbnails as images in
/// Flutter.
///
/// Use this class to load a video thumbnail as an image. It takes a video URL
/// or path and generates a thumbnail image from the video. The generated
/// thumbnail image can be used with the [Image] widget.
///
/// {@tool snippet}
/// Load a video thumbnail from a URL:
///
/// ```dart
/// Image(
///   image: StreamVideoThumbnailImage(
///     video: 'https://example.com/video.mp4',
///     maxHeight: 200,
///     maxWidth: 200,
///   ),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// Load a video thumbnail from a local file path:
///
/// ```dart
/// Image(
///   image: StreamVideoThumbnailImage(
///     video: '/path/to/video.mp4',
///     maxHeight: 200,
///     maxWidth: 200,
///   ),
/// )
/// ```
/// {@end-tool}
/// {@endtemplate}
class StreamVideoThumbnailImage
    extends ImageProvider<StreamVideoThumbnailImage> {
  /// {@macro video_thumbnail_image}
  const StreamVideoThumbnailImage({
    required this.video,
    this.headers,
    this.imageFormat = ImageFormat.PNG,
    this.maxHeight = 0,
    this.maxWidth = 0,
    this.timeMs = 0,
    this.quality = 10,
    this.scale = 1.0,
  });

  /// The URL or path of the video from which to generate the thumbnail.
  final String video;

  /// Additional headers to include in the HTTP request when fetching the video.
  final Map<String, String>? headers;

  /// The format of the generated thumbnail image.
  final ImageFormat imageFormat;

  /// The maximum height of the generated thumbnail image.
  final int maxHeight;

  /// The maximum width of the generated thumbnail image.
  final int maxWidth;

  /// The timestamp in milliseconds at which to generate the thumbnail.
  final int timeMs;

  /// The quality of the generated thumbnail image.
  final int quality;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  @override
  Future<StreamVideoThumbnailImage> obtainKey(
    ImageConfiguration configuration,
  ) {
    return SynchronousFuture<StreamVideoThumbnailImage>(this);
  }

  @override
  @Deprecated('Will get replaced by loadImage in the next major version.')
  ImageStreamCompleter loadBuffer(
    StreamVideoThumbnailImage key,
    DecoderBufferCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.video,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<StreamVideoThumbnailImage>('Image key', key),
      ],
    );
  }

  @Deprecated('Will get replaced by loadImage in the next major version.')
  Future<ui.Codec> _loadAsync(
    StreamVideoThumbnailImage key,
    DecoderBufferCallback decode,
  ) async {
    assert(key == this, '$key is not $this');

    final bytes = await StreamVideoService.generateVideoThumbnail(
      video: key.video,
      headers: key.headers,
      imageFormat: key.imageFormat,
      maxHeight: key.maxHeight,
      maxWidth: key.maxWidth,
      timeMs: key.timeMs,
      quality: key.quality,
    );

    if (bytes == null || bytes.lengthInBytes == 0) {
      throw Exception('VideoThumbnailImage is an empty file: ${key.video}');
    }

    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is StreamVideoThumbnailImage &&
        other.video == video &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(video, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'StreamVideoThumbnailImage')}($video, scale: $scale)';
}
