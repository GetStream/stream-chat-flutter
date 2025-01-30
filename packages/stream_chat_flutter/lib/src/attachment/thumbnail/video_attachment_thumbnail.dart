import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_error.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

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
    this.errorBuilder = _defaultErrorBuilder,
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
  final ThumbnailErrorBuilder errorBuilder;

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
    final thumbUrl = video.thumbUrl;
    if (thumbUrl != null) {
      return CachedNetworkImage(
        imageUrl: thumbUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, __) {
          final image = Image.asset(
            'lib/assets/images/placeholder.png',
            width: width,
            height: height,
            fit: BoxFit.cover,
            package: 'stream_chat_flutter',
          );

          final colorTheme = StreamChatTheme.of(context).colorTheme;
          return Shimmer.fromColors(
            baseColor: colorTheme.disabled,
            highlightColor: colorTheme.inputBg,
            child: image,
          );
        },
        errorWidget: (context, url, error) {
          return errorBuilder(
            context,
            error,
            StackTrace.current,
          );
        },
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
          if (frame != null || wasSynchronouslyLoaded) {
            return child;
          }

          final image = Image.asset(
            'lib/assets/images/placeholder.png',
            width: width,
            height: height,
            fit: BoxFit.cover,
            package: 'stream_chat_flutter',
          );

          final colorTheme = StreamChatTheme.of(context).colorTheme;
          return Shimmer.fromColors(
            baseColor: colorTheme.disabled,
            highlightColor: colorTheme.inputBg,
            child: image,
          );
        },
        errorBuilder: errorBuilder,
      );
    }

    // Return error widget if no thumbnail is found.
    return errorBuilder(
      context,
      'Video attachment is not valid',
      StackTrace.current,
    );
  }
}
