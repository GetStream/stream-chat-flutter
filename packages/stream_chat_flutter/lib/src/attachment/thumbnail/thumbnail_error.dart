import 'package:flutter/material.dart';

/// {@template thumbnailErrorBuilder}
/// Signature for the builder callback used by [ThumbnailError.builder].
///
/// The parameters represent the [BuildContext], [error] and [stackTrace] of the
/// error that triggered this callback.
/// {@endtemplate}
typedef ThumbnailErrorBuilder = Widget Function(
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
  });

  /// The error that triggered this error widget.
  final Object error;

  /// The stack trace of the error that triggered this error widget.
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/placeholder.png',
      fit: BoxFit.cover,
      package: 'stream_chat_flutter',
    );
  }
}
