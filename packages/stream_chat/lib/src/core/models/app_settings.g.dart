// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  name: json['name'] as String,
  fileUploadConfig: UploadConfig.fromJson(
    json['file_upload_config'] as Map<String, dynamic>,
  ),
  imageUploadConfig: UploadConfig.fromJson(
    json['image_upload_config'] as Map<String, dynamic>,
  ),
  autoTranslationEnabled: json['auto_translation_enabled'] as bool,
  asyncUrlEnrichEnabled: json['async_url_enrich_enabled'] as bool,
);

UploadConfig _$UploadConfigFromJson(Map<String, dynamic> json) => UploadConfig(
  sizeLimitInBytes: (json['size_limit'] as num?)?.toInt(),
  allowedFileExtensions: (json['allowed_file_extensions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  blockedFileExtensions: (json['blocked_file_extensions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  allowedMimeTypes: (json['allowed_mime_types'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  blockedMimeTypes: (json['blocked_mime_types'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
);
