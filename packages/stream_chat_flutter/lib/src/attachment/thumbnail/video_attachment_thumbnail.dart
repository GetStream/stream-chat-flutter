import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/image_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_error.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template videoAttachmentThumbnail}
/// Widget for building video attachment thumbnail.
///
/// This widget is used when the [Attachment.type] is [AttachmentType.video].
/// {@endtemplate}
class StreamVideoAttachmentThumbnail extends StatelessWidget {
  /// {@macro videoAttachmentThumbnail}
  const StreamVideoAttachmentThumbnail({
    super.key,
    required this.video,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  /// The video attachment to build the thumbnail for.
  final Attachment video;

  /// The width of the thumbnail.
  final double? width;

  /// The height of the thumbnail.
  final double? height;

  /// How to inscribe the thumbnail into the space allocated during layout.
  final BoxFit? fit;

  /// Builder used when the thumbnail fails to load.
  ///
  /// If null, default error handling is used.
  final ThumbnailErrorBuilder? errorBuilder;

  // Default error builder for video attachment thumbnail.
  Widget _defaultErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    if (errorBuilder case final builder?) return builder(context, error, null);
    return StreamImageErrorPlaceholder(width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    final containsThumbnail = video.thumbUrl != null;
    // If thumbnail is available, we can directly show it using the
    // StreamImageAttachmentThumbnail widget.
    if (containsThumbnail) {
      return StreamImageAttachmentThumbnail(
        image: video,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    final filePath = video.file?.path;
    final videoAssetUrl = video.assetUrl;
    if (filePath != null || videoAssetUrl != null) {
      return Image(
        image: StreamVideoThumbnailImage(video: filePath ?? videoAssetUrl!),
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame != null || wasSynchronouslyLoaded) return child;
          return StreamImageLoadingPlaceholder(height: height, width: width);
        },
        errorBuilder: _defaultErrorBuilder,
      );
    }

    return _defaultErrorBuilder(
      context,
      'Video attachment is not valid',
      StackTrace.current,
    );
  }
}
