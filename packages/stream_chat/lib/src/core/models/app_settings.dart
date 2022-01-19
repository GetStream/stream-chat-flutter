import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

/// Model class to store app specific settings.
@JsonSerializable()
class AppSettings {
  /// Create a new instance of [AppSettings] class.
  const AppSettings(
    this.name,
    this.fileUploadConfig,
    this.imageUploadConfig,
  );

  /// Create a new instance from a json
  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  /// Application name.
  final String? name;

  /// Configuration for a file upload.
  final FileUploadConfig? fileUploadConfig;

  /// Configuration for a image upload.
  final FileUploadConfig? imageUploadConfig;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

/// Class that represents the configuration for a file upload.
@JsonSerializable()
class FileUploadConfig {
  /// Creates a new instance of the [FileUploadConfig] class.
  const FileUploadConfig({
    this.allowedFileExtensions = const [],
    this.blockedFileExtensions = const [],
    this.allowedMimeTypes = const [],
    this.blockedMimeTypes = const [],
  });

  /// Create a new instance from a json
  factory FileUploadConfig.fromJson(Map<String, dynamic> json) =>
      _$FileUploadConfigFromJson(json);

  /// An array of file types that the user can submit.
  ///
  /// e.g: [".gif", ".png", ".jpg"]
  final List<String> allowedFileExtensions;

  /// An array of file types that the user can submit.
  ///
  /// e.g: [".tar", ".tiff", ".jpg"]
  final List<String> blockedFileExtensions;

  /// An array of file MIME types that the user can submit. Must follow the
  /// type/ subtype pattern.
  ///
  /// e.g: ["image/jpeg", "image/svg+xml", "image/png"]
  final List<String> allowedMimeTypes;

  /// An array of file types that the user can submit. Must follow the
  /// type/ subtype pattern.
  ///
  /// e.g: ["text/css", "text/plain", "image/tiff"]
  final List<String> blockedMimeTypes;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$FileUploadConfigToJson(this);
}
