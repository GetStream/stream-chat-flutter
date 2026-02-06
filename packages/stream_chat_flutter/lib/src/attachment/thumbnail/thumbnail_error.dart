import 'package:flutter/material.dart';

/// {@template thumbnailErrorBuilder}
/// Signature for the builder callback used by [ThumbnailError.builder].
///
/// The parameters represent the [BuildContext], [error] and [stackTrace] of the
/// error that triggered this callback.
/// {@endtemplate}
typedef ThumbnailErrorBuilder =
    Widget Function(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    );

/// {@template thumbnailError}
/// A widget that shows an error state when a thumbnail fails to load.
/// {@endtemplate}
class ThumbnailError extends StatelessWidget {
  /// {@macro thumbnailError}
  const ThumbnailError({
    super.key,
    required this.error,
    this.stackTrace,
    this.width,
    this.height,
    this.fit,
  });

  /// The width of the thumbnail.
  final double? width;

  /// The height of the thumbnail.
  final double? height;

  /// How to inscribe the thumbnail into the space allocated during layout.
  final BoxFit? fit;

  /// The error that triggered this error widget.
  final Object error;

  /// The stack trace of the error that triggered this error widget.
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/placeholder.png',
      width: width,
      height: height,
      fit: fit,
      package: 'stream_chat_flutter',
    );
  }
}
