import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

/// {@template appSettings}
/// The configuration of a Stream Chat application.
///
/// Carries the upload rules applied to file and image attachments, as
/// configured in the Stream Dashboard.
///
/// See also:
///
///  * [UploadConfig], for the per-category upload rules.
///  * [StreamChatClient.appSettings], for the cached value held by the
///    client.
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class AppSettings extends Equatable {
  /// {@macro appSettings}
  const AppSettings({
    this.name = '',
    this.fileUploadConfig = const UploadConfig(),
    this.imageUploadConfig = const UploadConfig(),
  });

  /// Creates a new instance from a json.
  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  /// The display name of the application.
  final String name;

  /// The upload rules applied to non-image attachments.
  final UploadConfig fileUploadConfig;

  /// The upload rules applied to image attachments.
  final UploadConfig imageUploadConfig;

  @override
  List<Object?> get props => [name, fileUploadConfig, imageUploadConfig];
}

/// {@template uploadConfig}
/// The upload rules for a single category of attachment.
///
/// Each instance is paired with one category, see
/// [AppSettings.fileUploadConfig] and [AppSettings.imageUploadConfig].
///
/// An upload is accepted only when it satisfies every non-empty list and
/// stays within [sizeLimit]:
///
///  * [allowedFileExtensions]: the file's extension must appear in the list.
///  * [blockedFileExtensions]: the file's extension must not appear in the
///    list.
///  * [allowedMimeTypes]: the file's MIME type must appear in the list.
///  * [blockedMimeTypes]: the file's MIME type must not appear in the list.
/// {@endtemplate}
@JsonSerializable(createToJson: false)
class UploadConfig extends Equatable {
  /// {@macro uploadConfig}
  const UploadConfig({
    this.sizeLimit = UploadConfig.defaultSizeLimit,
    this.allowedFileExtensions = const [],
    this.blockedFileExtensions = const [],
    this.allowedMimeTypes = const [],
    this.blockedMimeTypes = const [],
  });

  /// Creates a new instance from a json.
  factory UploadConfig.fromJson(Map<String, dynamic> json) =>
      _$UploadConfigFromJson(json);

  /// The size limit used when no explicit value is configured.
  static const defaultSizeLimit = 100 * 1024 * 1024;

  /// The maximum upload size, in bytes.
  ///
  /// Defaults to [defaultSizeLimit] when no limit is configured.
  @JsonKey(fromJson: _sizeLimitFromJson)
  final int sizeLimit;

  // The backend sends `0` when no size limit is configured.
  static int _sizeLimitFromJson(int sizeLimit) {
    return sizeLimit > 0 ? sizeLimit : defaultSizeLimit;
  }

  /// The file extensions explicitly permitted, e.g. `['.pdf', '.csv']`.
  @JsonKey(defaultValue: [])
  final List<String> allowedFileExtensions;

  /// The file extensions explicitly blocked, e.g. `['.exe']`.
  @JsonKey(defaultValue: [])
  final List<String> blockedFileExtensions;

  /// The MIME types explicitly permitted, e.g. `['text/csv', 'image/png']`.
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
