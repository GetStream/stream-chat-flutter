// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      name: json['name'] as String? ?? '',
      fileUploadConfig: json['file_upload_config'] == null
          ? const UploadConfig()
          : UploadConfig.fromJson(
              json['file_upload_config'] as Map<String, dynamic>),
      imageUploadConfig: json['image_upload_config'] == null
          ? const UploadConfig()
          : UploadConfig.fromJson(
              json['image_upload_config'] as Map<String, dynamic>),
    );

UploadConfig _$UploadConfigFromJson(Map<String, dynamic> json) => UploadConfig(
      sizeLimit: json['size_limit'] == null
          ? UploadConfig.defaultSizeLimit
          : UploadConfig._sizeLimitFromJson(
              (json['size_limit'] as num).toInt()),
      allowedFileExtensions: (json['allowed_file_extensions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      blockedFileExtensions: (json['blocked_file_extensions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      allowedMimeTypes: (json['allowed_mime_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      blockedMimeTypes: (json['blocked_mime_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
