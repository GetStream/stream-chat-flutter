import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'extensions.dart';

/// Resolves a title and description for [error].
///
/// A request that timed out maps to the "slow connection" copy and any other
/// failure to reach the server to the "no internet" copy. Everything else falls back to [fallbackTitle] /
/// [fallbackDescription] when provided, otherwise to the generic localized copy.
({String title, String description}) resolveNetworkErrorText(
  BuildContext context,
  Object? error, {
  String? fallbackTitle,
  String? fallbackDescription,
}) {
  final translations = context.translations;
  return switch (error) {
    StreamNetworkException(isTimeout: true) => (
      title: translations.slowConnectionErrorTitle,
      description: translations.slowConnectionErrorDescription,
    ),
    StreamNetworkException() => (
      title: translations.connectionErrorTitle,
      description: translations.connectionErrorDescription,
    ),
    _ => (
      title: fallbackTitle ?? translations.genericErrorTitle,
      description: fallbackDescription ?? translations.genericErrorDescription,
    ),
  };
}
