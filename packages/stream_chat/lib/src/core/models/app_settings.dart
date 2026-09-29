import 'package:freezed_annotation/freezed_annotation.dart';

import 'upload_config.dart';

part 'app_settings.freezed.dart';

/// {@template appSettings}
/// The configuration of a Stream Chat application.
///
/// Carries the upload constraints applied to file and image attachments
/// along with application-level feature flags configured for the app.
///
/// See also:
///
///  * [UploadConfig], for the per-category upload rules.
///  * [StreamChatClient.appSettings], for the cached value held by the
///    client.
/// {@endtemplate}
@freezed
class AppSettings with _$AppSettings {
  /// {@macro appSettings}
  const AppSettings({
    this.name = '',
    this.fileUploadConfig = const UploadConfig(),
    this.imageUploadConfig = const UploadConfig(),
    this.autoTranslationEnabled = false,
    this.asyncUrlEnrichEnabled = false,
  });

  /// The display name of the application.
  @override
  final String name;

  /// The upload rules applied to non-image attachments.
  @override
  final UploadConfig fileUploadConfig;

  /// The upload rules applied to image attachments.
  @override
  final UploadConfig imageUploadConfig;

  /// Whether automatic message translation is enabled for the app.
  @override
  final bool autoTranslationEnabled;

  /// Whether asynchronous URL enrichment is enabled for the app.
  @override
  final bool asyncUrlEnrichEnabled;
}
