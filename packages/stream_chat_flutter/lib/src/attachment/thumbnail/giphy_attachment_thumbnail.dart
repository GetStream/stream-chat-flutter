import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/image_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_error.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template giphyAttachmentThumbnail}
/// Widget for building giphy attachment thumbnail.
///
/// This widget is used when the [Attachment.type] is [AttachmentType.giphy].
/// {@endtemplate}
class StreamGiphyAttachmentThumbnail extends StatelessWidget {
  /// {@macro giphyAttachmentThumbnail}
  const StreamGiphyAttachmentThumbnail({
    super.key,
    required this.giphy,
    this.type = GiphyInfoType.original,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder = _defaultErrorBuilder,
  });

  /// The giphy attachment to build the thumbnail for.
  final Attachment giphy;

  /// The type of giphy thumbnail to build.
  final GiphyInfoType type;

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
    );
  }

  @override
  Widget build(BuildContext context) {
    // If the giphy info is not available, use the image attachment thumbnail
    // instead.
    final info = giphy.giphyInfo(type);
    if (info == null) {
      return StreamImageAttachmentThumbnail(
        image: giphy,
        width: width,
        height: height,
        fit: fit,
      );
    }

    return CachedNetworkImage(
      imageUrl: info.url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, __) {
        final image = Image.asset(
          'images/placeholder.png',
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
