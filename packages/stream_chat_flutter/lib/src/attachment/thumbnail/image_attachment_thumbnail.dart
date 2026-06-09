import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_size_calculator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
    this.resize,
    this.errorBuilder,
  });

  /// The image attachment to show.
  final Attachment image;

  /// Width of the attachment image thumbnail.
  final double? width;

  /// Height of the attachment image thumbnail.
  final double? height;

  /// Fit of the attachment image thumbnail.
  final BoxFit? fit;

  /// The resize configuration for the image attachment thumbnail.
  ///
  /// When provided, its [ImageResize.width] and [ImageResize.height] are used
  /// directly as the CDN resize dimensions.
  ///
  /// When null, the size is auto-calculated from the layout constraints
  /// and defaults to [ResizeMode.clip] and [CropMode.center].
  final ImageResize? resize;

  /// Builder used when the thumbnail fails to load.
  ///
  /// If null, the default error handling of the underlying image widget is
  /// used. For remote images, [StreamNetworkImage] provides a tap-to-retry
  /// error placeholder. For local images, a static
  /// [StreamImageErrorPlaceholder] is shown.
  final ThumbnailErrorBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var effectiveResize = resize;
        if (effectiveResize == null) {
          final size = ThumbnailSizeCalculator.calculate(
            targetSize: constraints.biggest,
            originalSize: image.originalSize,
            pixelRatio: MediaQuery.devicePixelRatioOf(context),
            fit: fit,
          );

          if (size != null) effectiveResize = .new(width: size.width, height: size.height);
        }

        final cacheWidth = effectiveResize?.width.round();
        final cacheHeight = effectiveResize?.height.round();

        // If the remote image URL is available, we can directly show it using
        // the _RemoteImageAttachment widget.
        final imageUrl = image.thumbUrl ?? image.imageUrl ?? image.assetUrl;
        if (imageUrl case final imageUrl?) {
          final imageCDN = StreamChatConfiguration.maybeOf(context)?.imageCDN ?? const StreamImageCDN();
          final resolvedUrl = imageCDN.resolveUrl(imageUrl, resize: effectiveResize);
          final resolvedCacheKey = imageCDN.cacheKey(resolvedUrl);

          return _RemoteImageAttachment(
            url: resolvedUrl,
            cacheKey: resolvedCacheKey,
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

        if (errorBuilder case final builder?) {
          return builder(context, 'Image attachment is not valid', null);
        }

        return StreamImageErrorPlaceholder(width: width, height: height);
      },
    );
  }
}

class _LocalImageAttachment extends StatelessWidget {
  const _LocalImageAttachment({
    required this.file,
    this.errorBuilder,
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
  final ThumbnailErrorBuilder? errorBuilder;

  // Default error builder for local attachment thumbnail.
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
    final bytes = file.bytes;
    if (bytes != null) {
      return Image.memory(
        bytes,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        fit: fit,
        errorBuilder: _defaultErrorBuilder,
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
        errorBuilder: _defaultErrorBuilder,
      );
    }

    // Return error widget if no image is found.
    return _defaultErrorBuilder(
      context,
      'Image attachment is not valid',
      StackTrace.current,
    );
  }
}

class _RemoteImageAttachment extends StatelessWidget {
  const _RemoteImageAttachment({
    required this.url,
    this.cacheKey,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
    this.errorBuilder,
  });

  final String url;
  final String? cacheKey;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ThumbnailErrorBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamNetworkImage(
      url,
      cacheKey: cacheKey,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
