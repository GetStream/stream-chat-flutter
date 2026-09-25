import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_config.freezed.dart';

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
@freezed
class UploadConfig with _$UploadConfig {
  /// {@macro uploadConfig}
  const UploadConfig({
    this.sizeLimit = defaultSizeLimit,
    this.allowedFileExtensions = const [],
    this.blockedFileExtensions = const [],
    this.allowedMimeTypes = const [],
    this.blockedMimeTypes = const [],
  });

  /// The fallback used for [sizeLimit] when no explicit value is provided.
  static const defaultSizeLimit = 100 * 1024 * 1024;

  /// The maximum upload size, in bytes.
  ///
  /// Defaults to [defaultSizeLimit].
  @override
  final int sizeLimit;

  /// The file extensions explicitly permitted, e.g. `['.pdf', '.csv']`.
  ///
  /// When non-empty, only listed extensions pass.
  @override
  final List<String> allowedFileExtensions;

  /// The file extensions explicitly blocked.
  @override
  final List<String> blockedFileExtensions;

  /// The MIME types explicitly permitted, e.g. `['text/csv', 'image/png']`.
  ///
  /// When non-empty, only listed MIME types pass.
  @override
  final List<String> allowedMimeTypes;

  /// The MIME types explicitly blocked.
  @override
  final List<String> blockedMimeTypes;
}
