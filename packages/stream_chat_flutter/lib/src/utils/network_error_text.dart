import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Resolves a title and description for [error] based on its transport-level
/// [StreamChatNetworkError.type].
///
/// Connection failures map to the "no internet" copy and timeouts to the
/// "slow connection" copy. Everything else falls back to [fallbackTitle] /
/// [fallbackDescription] when provided, otherwise to the generic localized copy.
({String title, String description}) resolveNetworkErrorText(
  BuildContext context,
  Object? error, {
  String? fallbackTitle,
  String? fallbackDescription,
}) {
  final translations = context.translations;
  return switch (error) {
    StreamChatNetworkError(type: .connectionError) => (
      title: translations.connectionErrorTitle,
      description: translations.connectionErrorDescription,
    ),
    StreamChatNetworkError(type: .connectionTimeout || .sendTimeout || .receiveTimeout) => (
      title: translations.slowConnectionErrorTitle,
      description: translations.slowConnectionErrorDescription,
    ),
    _ => (
      title: fallbackTitle ?? translations.genericErrorTitle,
      description: fallbackDescription ?? translations.genericErrorDescription,
    ),
  };
}
