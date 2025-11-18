import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/image_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/thumbnail_error.dart';
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
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the giphy info based on the selected type.
    final info = giphy.giphyInfo(type);
    // Build the image attachment thumbnail using the giphy info url if
    // available or fallback to the original giphy url.
    return StreamImageAttachmentThumbnail(
      image: giphy.copyWith(imageUrl: info?.url),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
