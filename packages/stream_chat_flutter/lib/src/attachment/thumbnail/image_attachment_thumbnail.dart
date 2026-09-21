import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_error.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_size_calculator.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
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
    this.resize,
    @Deprecated("Use 'resize' instead") this.thumbnailSize,
    @Deprecated("Use 'resize' instead") this.thumbnailResizeType,
    @Deprecated("Use 'resize' instead") this.thumbnailCropType,
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

  /// The resize configuration for the image attachment thumbnail.
  ///
  /// When provided, its [ImageResize.width] and [ImageResize.height] are used
  /// directly as the CDN resize dimensions.
  ///
  /// When null, the size is auto-calculated from the layout constraints and
  /// defaults to [ResizeMode.clip] and [CropMode.center].
  final ImageResize? resize;

  /// Size of the attachment image thumbnail.
  final Size? thumbnailSize;

  /// Resize type of the image attachment thumbnail.
  ///
  /// Defaults to [ResizeMode.clip].
  final String? /*clip|crop|scale|fill*/ thumbnailResizeType;

  /// Crop type of the image attachment thumbnail.
  ///
  /// Defaults to [CropMode.center].
  final String? /*center|top|bottom|left|right*/ thumbnailCropType;

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

  static ResizeMode _resizeMode(String? value) {
    return ResizeMode.values.firstWhere(
      (it) => it.value == value,
      orElse: () => ResizeMode.clip,
    );
  }

  static CropMode _cropMode(String? value) {
    return CropMode.values.firstWhere(
      (it) => it.value == value,
      orElse: () => CropMode.center,
    );
  }

  bool _hasDeprecatedOptions() {
    var hasDeprecatedOptions = thumbnailSize != null;
    hasDeprecatedOptions |= thumbnailResizeType != null;
    hasDeprecatedOptions |= thumbnailCropType != null;
    return hasDeprecatedOptions;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      resize == null || !_hasDeprecatedOptions(),
      'Cannot provide both a resize and the deprecated thumbnail options',
    );

    final imageCDN = StreamChatConfiguration.of(context).imageCDN;

    return LayoutBuilder(
      builder: (context, constraints) {
        var effectiveResize = resize;
        if (effectiveResize == null) {
          final size = switch (thumbnailSize) {
            final thumbnailSize? => thumbnailSize,
            _ => ThumbnailSizeCalculator.calculate(
                targetSize: constraints.biggest,
                originalSize: image.originalSize,
                pixelRatio: MediaQuery.devicePixelRatioOf(context),
              ),
          };

          if (size != null) {
            effectiveResize = ImageResize(
              width: size.width,
              height: size.height,
              mode: _resizeMode(thumbnailResizeType),
              crop: _cropMode(thumbnailCropType),
            );
          }
        }

        final cacheWidth = effectiveResize?.width.round();
        final cacheHeight = effectiveResize?.height.round();

        // If the remote image URL is available, we can directly show it using
        // the _RemoteImageAttachment widget.
        final imageUrl = image.thumbUrl ?? image.imageUrl ?? image.assetUrl;
        if (imageUrl case final imageUrl?) {
          final resolvedUrl = imageCDN.resolveUrl(
            imageUrl,
            resize: effectiveResize,
          );

          return _RemoteImageAttachment(
            url: resolvedUrl,
            cacheKey: imageCDN.cacheKey(resolvedUrl),
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
    this.cacheKey,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.fit,
  });

  final String url;
  final String? cacheKey;
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
      cacheKey: cacheKey,
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
