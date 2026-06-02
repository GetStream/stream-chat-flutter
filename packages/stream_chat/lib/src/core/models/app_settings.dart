import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

/// The top-level app configuration returned by the `GET /app` endpoint.
@JsonSerializable(createToJson: false)
class AppSettings {
  /// Creates a new [AppSettings] instance.
  AppSettings({
    required this.name,
    required this.fileUploadConfig,
    required this.imageUploadConfig,
    required this.autoTranslationEnabled,
    required this.asyncUrlEnrichEnabled,
  });

  /// Creates a new instance from a json.
  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  /// The name of the app.
  final String name;

  /// Upload configuration for file attachments.
  @JsonKey(name: 'file_upload_config')
  final UploadConfig fileUploadConfig;

  /// Upload configuration for image attachments.
  @JsonKey(name: 'image_upload_config')
  final UploadConfig imageUploadConfig;

  /// Whether auto-translation is enabled.
  @JsonKey(name: 'auto_translation_enabled')
  final bool autoTranslationEnabled;

  /// Whether async URL enrichment is enabled.
  @JsonKey(name: 'async_url_enrich_enabled')
  final bool asyncUrlEnrichEnabled;
}

/// Upload configuration for a specific attachment category (file or image).
@JsonSerializable(createToJson: false)
class UploadConfig {
  /// Creates a new [UploadConfig] instance.
  UploadConfig({
    this.sizeLimit,
    this.allowedFileExtensions = const [],
    this.blockedFileExtensions = const [],
    this.allowedMimeTypes = const [],
    this.blockedMimeTypes = const [],
  });

  /// Creates a new instance from a json.
  factory UploadConfig.fromJson(Map<String, dynamic> json) => _$UploadConfigFromJson(json);

  /// Maximum allowed upload size in bytes.
  ///
  /// A value of `0` or `null` means "use the SDK default".
  @JsonKey(name: 'size_limit')
  final int? sizeLimit;

  /// File extensions that are explicitly allowed (e.g. `['.pdf', '.csv']`).
  /// When non-empty, only listed extensions are permitted.
  @JsonKey(name: 'allowed_file_extensions', defaultValue: [])
  final List<String> allowedFileExtensions;

  /// File extensions that are explicitly blocked.
  @JsonKey(name: 'blocked_file_extensions', defaultValue: [])
  final List<String> blockedFileExtensions;

  /// MIME types that are explicitly allowed (e.g. `['text/csv', 'image/png']`).
  /// When non-empty, only listed MIME types are permitted.
  @JsonKey(name: 'allowed_mime_types', defaultValue: [])
  final List<String> allowedMimeTypes;

  /// MIME types that are explicitly blocked.
  @JsonKey(name: 'blocked_mime_types', defaultValue: [])
  final List<String> blockedMimeTypes;

  /// Returns whether an attachment with the given [fileExtension] and/or
  /// [mimeType] is permitted by this configuration.
  ///
  /// Logic (mirrors Swift `UploadConfig.isAllowed`):
  /// 1. If blocked by extension → rejected.
  /// 2. If an allow-list exists and the extension is not in it → rejected.
  /// 3. Same check for mime type.
  /// 4. Otherwise → allowed.
  bool isAllowed({String? fileExtension, String? mimeType}) {
    return _isValueAllowed(
          value: fileExtension,
          allowed: allowedFileExtensions,
          blocked: blockedFileExtensions,
        ) &&
        _isValueAllowed(
          value: mimeType,
          allowed: allowedMimeTypes,
          blocked: blockedMimeTypes,
        );
  }

  static bool _isValueAllowed({
    required String? value,
    required List<String> allowed,
    required List<String> blocked,
  }) {
    if (value == null) return true;
    // Normalise: lower-case and strip leading dots for extension comparison.
    final v = value.toLowerCase().replaceFirst(RegExp(r'^\.'), '');

    String normalise(String s) => s.toLowerCase().replaceFirst(RegExp(r'^\.'), '');

    if (blocked.any((b) => normalise(b) == v)) return false;
    if (allowed.isEmpty) return true;
    return allowed.any((a) => normalise(a) == v);
  }
}
