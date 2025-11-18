import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_error.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_size_calculator.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template imageAttachmentThumbnail}
/// Widget for building image attachment thumbnail.
///
/// This widget is used when the [Attachment.type] is [AttachmentType.image].
/// {@endtemplate}
class StreamImageAttachmentThumbnail extends StatelessWidget {
  /// {@macro imageAttachmentThumbnail}
  const StreamImageAttachmentThumbnail({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
    this.thumbnailSize,
    this.thumbnailResizeType = 'clip',
    this.thumbnailCropType = 'center',
    this.errorBuilder = _defaultErrorBuilder,
  });

  /// The image attachment to show.
  final Attachment image;

  /// Width of the attachment image thumbnail.
  final double? width;

  /// Height of the attachment image thumbnail.
  final double? height;

  /// Fit of the attachment image thumbnail.
  final BoxFit? fit;

  /// Size of the attachment image thumbnail.
  final Size? thumbnailSize;

  /// Resize type of the image attachment thumbnail.
  ///
  /// Defaults to [crop]
  final String /*clip|crop|scale|fill*/ thumbnailResizeType;

  /// Crop type of the image attachment thumbnail.
  ///
  /// Defaults to [center]
  final String /*center|top|bottom|left|right*/ thumbnailCropType;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate optimal thumbnail size once for all paths
        final effectiveThumbnailSize = switch (thumbnailSize) {
          final thumbnailSize? => thumbnailSize,
          _ => ThumbnailSizeCalculator.calculate(
              targetSize: constraints.biggest,
              originalSize: image.originalSize,
              pixelRatio: MediaQuery.devicePixelRatioOf(context),
            ),
        };

        final cacheWidth = effectiveThumbnailSize?.width.round();
        final cacheHeight = effectiveThumbnailSize?.height.round();

        // If the remote image URL is available, we can directly show it using
        // the _RemoteImageAttachment widget.
        if (image.thumbUrl ?? image.imageUrl case final imageUrl?) {
          var resizedImageUrl = imageUrl;
          if (effectiveThumbnailSize case final thumbnailSize?) {
            resizedImageUrl = imageUrl.getResizedImageUrl(
              crop: thumbnailCropType,
              resize: thumbnailResizeType,
              width: thumbnailSize.width,
              height: thumbnailSize.height,
            );
          }

          return _RemoteImageAttachment(
            url: resizedImageUrl,
            width: width,
            height: height,
            fit: fit,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            errorBuilder: errorBuilder,
          );
        }

        // Otherwise, we try to show the local image file.
        if (image.file case final file?) {
          return _LocalImageAttachment(
            file: file,
            width: width,
            height: height,
            fit: fit,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            errorBuilder: errorBuilder,
          );
        }

        return errorBuilder(
          context,
          'Image attachment is not valid',
          StackTrace.current,
        );
      },
    );
  }
}

class _LocalImageAttachment extends StatelessWidget {
  const _LocalImageAttachment({
    required this.file,
    required this.errorBuilder,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
  });

  final AttachmentFile file;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ThumbnailErrorBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    final bytes = file.bytes;
    if (bytes != null) {
      return Image.memory(
        bytes,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    final path = file.path;
    if (path != null) {
      return Image.file(
        File(path),
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        fit: fit,
        errorBuilder: errorBuilder,
      );
    }

    // Return error widget if no image is found.
    return errorBuilder(
      context,
      'Image attachment is not valid',
      StackTrace.current,
    );
  }
}

class _RemoteImageAttachment extends StatelessWidget {
  const _RemoteImageAttachment({
    required this.url,
    required this.errorBuilder,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
  });

  final String url;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ThumbnailErrorBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
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
}
