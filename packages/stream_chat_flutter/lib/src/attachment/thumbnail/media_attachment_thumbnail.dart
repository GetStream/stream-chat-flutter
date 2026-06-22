import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/giphy_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/image_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_error.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/video_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/utils/stream_image_cdn.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template mediaAttachmentThumbnail}
/// Widget for building media attachment thumbnail.
///
/// This widget is used when the [Attachment.type] is [AttachmentType.image],
/// [AttachmentType.video] or [AttachmentType.giphy].
///
/// see also:
///   * [StreamImageAttachmentThumbnail]
///   * [StreamVideoAttachmentThumbnail]
///   * [StreamGiphyAttachmentThumbnail]
/// {@endtemplate}
class StreamMediaAttachmentThumbnail extends StatelessWidget {
  /// {@macro mediaAttachmentThumbnail}
  const StreamMediaAttachmentThumbnail({
    super.key,
    required this.media,
    this.width,
    this.height,
    this.fit,
    this.resize,
    this.gifInfoType = GiphyInfoType.original,
    this.errorBuilder,
  });

  /// The giphy attachment to build the thumbnail for.
  final Attachment media;

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

  /// The resize configuration for the image attachment thumbnail.
  ///
  /// When provided, its [ImageResize.width] and [ImageResize.height] are used
  /// directly as the CDN resize dimensions.
  ///
  /// When null, the size is auto-calculated from the layout constraints
  /// and defaults to [ResizeMode.clip] and [CropMode.center].
  ///
  /// Ignored if the [Attachment.type] is not [AttachmentType.image].
  final ImageResize? resize;

  /// The type of giphy thumbnail to build.
  ///
  /// Ignored if the [Attachment.type] is not [AttachmentType.giphy].
  final GiphyInfoType gifInfoType;

  // Default error builder for media attachment thumbnail.
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
    final type = media.type;
    if (type == AttachmentType.image) {
      return StreamImageAttachmentThumbnail(
        image: media,
        width: width,
        height: height,
        fit: fit,
        resize: resize,
        errorBuilder: errorBuilder,
      );
    }

    if (type == AttachmentType.giphy) {
      return StreamGiphyAttachmentThumbnail(
        giphy: media,
        width: width,
        height: height,
        fit: fit,
        type: gifInfoType,
        errorBuilder: errorBuilder,
      );
    }

    if (type == AttachmentType.video) {
      return StreamVideoAttachmentThumbnail(
        video: media,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    return _defaultErrorBuilder(
      context,
      'Unsupported attachment type: $type',
      StackTrace.current,
    );
  }
}
