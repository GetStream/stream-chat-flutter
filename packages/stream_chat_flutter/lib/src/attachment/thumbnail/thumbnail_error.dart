import 'package:flutter/material.dart';

/// Signature for a function that builds an error widget when an attachment
/// thumbnail fails to load.
///
/// When [retry] is non-null, it can be invoked to retry loading the image
/// (e.g. to show a tap-to-reload button).
typedef ThumbnailErrorBuilder = Widget Function(BuildContext context, Object error, VoidCallback? retry);
