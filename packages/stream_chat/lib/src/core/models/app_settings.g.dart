// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      json['name'] as String?,
      json['file_upload_config'] == null
          ? null
          : FileUploadConfig.fromJson(
              json['file_upload_config'] as Map<String, dynamic>),
      json['image_upload_config'] == null
          ? null
          : FileUploadConfig.fromJson(
              json['image_upload_config'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'name': instance.name,
      'file_upload_config': instance.fileUploadConfig?.toJson(),
      'image_upload_config': instance.imageUploadConfig?.toJson(),
    };

FileUploadConfig _$FileUploadConfigFromJson(Map<String, dynamic> json) =>
    FileUploadConfig(
      allowedFileExtensions: (json['allowed_file_extensions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      blockedFileExtensions: (json['blocked_file_extensions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allowedMimeTypes: (json['allowed_mime_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      blockedMimeTypes: (json['blocked_mime_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$FileUploadConfigToJson(FileUploadConfig instance) =>
    <String, dynamic>{
      'allowed_file_extensions': instance.allowedFileExtensions,
      'blocked_file_extensions': instance.blockedFileExtensions,
      'allowed_mime_types': instance.allowedMimeTypes,
      'blocked_mime_types': instance.blockedMimeTypes,
    };
