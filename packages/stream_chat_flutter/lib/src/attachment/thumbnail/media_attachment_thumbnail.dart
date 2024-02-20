import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/giphy_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/image_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_error.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/video_attachment_thumbnail.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

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
    this.thumbnailSize,
    this.thumbnailResizeType = 'clip',
    this.thumbnailCropType = 'center',
    this.gifInfoType = GiphyInfoType.original,
    this.errorBuilder = _defaultErrorBuilder,
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
  final ThumbnailErrorBuilder errorBuilder;

  /// Size of the attachment image thumbnail.
  ///
  /// Ignored if the [Attachment.type] is not [AttachmentType.image].
  final Size? thumbnailSize;

  /// Resize type of the image attachment thumbnail.
  ///
  /// Defaults to [crop]
  ///
  /// Ignored if the [Attachment.type] is not [AttachmentType.image].
  final String /*clip|crop|scale|fill*/ thumbnailResizeType;

  /// Crop type of the image attachment thumbnail.
  ///
  /// Defaults to [center]
  ///
  /// Ignored if the [Attachment.type] is not [AttachmentType.image].
  final String /*center|top|bottom|left|right*/ thumbnailCropType;

  /// The type of giphy thumbnail to build.
  ///
  /// Ignored if the [Attachment.type] is not [AttachmentType.giphy].
  final GiphyInfoType gifInfoType;

  // Default error builder for image attachment thumbnail.
  static Widget _defaultErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return ThumbnailError(
      error: error,
      stackTrace: stackTrace,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
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
        thumbnailSize: thumbnailSize,
        thumbnailResizeType: thumbnailResizeType,
        thumbnailCropType: thumbnailCropType,
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

    return errorBuilder(
      context,
      'Unsupported attachment type: $type',
      StackTrace.current,
    );
  }
}
