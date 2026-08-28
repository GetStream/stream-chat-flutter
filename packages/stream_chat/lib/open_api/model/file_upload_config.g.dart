// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUploadConfig _$FileUploadConfigFromJson(Map<String, dynamic> json) =>
    FileUploadConfig(
      allowedFileExtensions: (json['allowed_file_extensions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allowedMimeTypes: (json['allowed_mime_types'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      blockedFileExtensions: (json['blocked_file_extensions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      blockedMimeTypes: (json['blocked_mime_types'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sizeLimit: (json['size_limit'] as num).toInt(),
    );

Map<String, dynamic> _$FileUploadConfigToJson(FileUploadConfig instance) =>
    <String, dynamic>{
      'allowed_file_extensions': instance.allowedFileExtensions,
      'allowed_mime_types': instance.allowedMimeTypes,
      'blocked_file_extensions': instance.blockedFileExtensions,
      'blocked_mime_types': instance.blockedMimeTypes,
      'size_limit': instance.sizeLimit,
    };
