import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

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
@JsonSerializable(createToJson: false)
class AppSettings with EquatableMixin {
  /// {@macro appSettings}
  const AppSettings({
    this.name = '',
    this.fileUploadConfig = const UploadConfig(),
    this.imageUploadConfig = const UploadConfig(),
    this.autoTranslationEnabled = false,
    this.asyncUrlEnrichEnabled = false,
  });

  /// Creates a new instance from a json.
  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  /// The display name of the application.
  final String name;

  /// The upload rules applied to non-image attachments.
  final UploadConfig fileUploadConfig;

  /// The upload rules applied to image attachments.
  final UploadConfig imageUploadConfig;

  /// Whether automatic message translation is enabled for the app.
  final bool autoTranslationEnabled;

  /// Whether asynchronous URL enrichment is enabled for the app.
  final bool asyncUrlEnrichEnabled;

  @override
  List<Object?> get props => [
    name,
    fileUploadConfig,
    imageUploadConfig,
    autoTranslationEnabled,
    asyncUrlEnrichEnabled,
  ];
}

/// {@template uploadConfig}
/// The upload rules for a single category of attachment.
///
/// Each instance is paired with one category — see
/// [AppSettings.fileUploadConfig] and [AppSettings.imageUploadConfig].
///
/// An upload is accepted only when it satisfies every populated list and
/// stays within [sizeLimit]:
///
///  * [allowedFileExtensions] — when non-empty, the file's extension must
///    appear in the list.
///  * [blockedFileExtensions] — the file's extension must not appear in
///    the list.
///  * [allowedMimeTypes] — when non-empty, the file's MIME type must
///    appear in the list.
///  * [blockedMimeTypes] — the file's MIME type must not appear in the
///    list.
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class UploadConfig with EquatableMixin {
  /// {@macro uploadConfig}
  const UploadConfig({
    this.sizeLimit = defaultSizeLimit,
    this.allowedFileExtensions = const [],
    this.blockedFileExtensions = const [],
    this.allowedMimeTypes = const [],
    this.blockedMimeTypes = const [],
  });

  /// Creates a new instance from a json.
  factory UploadConfig.fromJson(Map<String, dynamic> json) => _$UploadConfigFromJson(json);

  /// The fallback used for [sizeLimit] when no explicit value is provided.
  static const defaultSizeLimit = 100 * 1024 * 1024;

  /// The maximum upload size, in bytes.
  ///
  /// Defaults to [defaultSizeLimit].
  @JsonKey(defaultValue: defaultSizeLimit)
  final int sizeLimit;

  /// The file extensions explicitly permitted, e.g. `['.pdf', '.csv']`.
  ///
  /// When non-empty, only listed extensions pass.
  @JsonKey(defaultValue: [])
  final List<String> allowedFileExtensions;

  /// The file extensions explicitly blocked.
  @JsonKey(defaultValue: [])
  final List<String> blockedFileExtensions;

  /// The MIME types explicitly permitted, e.g. `['text/csv', 'image/png']`.
  ///
  /// When non-empty, only listed MIME types pass.
  @JsonKey(defaultValue: [])
  final List<String> allowedMimeTypes;

  /// The MIME types explicitly blocked.
  @JsonKey(defaultValue: [])
  final List<String> blockedMimeTypes;

  @override
  List<Object?> get props => [
    sizeLimit,
    allowedFileExtensions,
    blockedFileExtensions,
    allowedMimeTypes,
    blockedMimeTypes,
  ];
}
