import '../../../open_api/api.dart' as api;
import '../../core/models/app_settings.dart';
import '../../core/models/response/get_app_settings_response.dart';
import '../../core/models/upload_config.dart';

/// Maps a generated [api.FileUploadConfig] to an [UploadConfig].
extension FileUploadConfigMapper on api.FileUploadConfig {
  /// Converts this config into an [UploadConfig].
  UploadConfig toModel() => UploadConfig(
    sizeLimit: sizeLimit,
    allowedFileExtensions: allowedFileExtensions,
    blockedFileExtensions: blockedFileExtensions,
    allowedMimeTypes: allowedMimeTypes,
    blockedMimeTypes: blockedMimeTypes,
  );
}

/// Maps a generated [api.AppResponseFields] to an [AppSettings].
extension AppResponseFieldsMapper on api.AppResponseFields {
  /// Converts these fields into an [AppSettings].
  AppSettings toModel() => AppSettings(
    name: name,
    fileUploadConfig: fileUploadConfig.toModel(),
    imageUploadConfig: imageUploadConfig.toModel(),
    autoTranslationEnabled: autoTranslationEnabled,
    asyncUrlEnrichEnabled: asyncUrlEnrichEnabled,
  );
}

/// Maps a generated [api.GetApplicationResponse] to a [GetAppSettingsResponse].
extension GetApplicationResponseMapper on api.GetApplicationResponse {
  /// Converts this response into a [GetAppSettingsResponse].
  GetAppSettingsResponse toModel() => GetAppSettingsResponse(
    duration: duration,
    app: app.toModel(),
  );
}
