// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_response_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppResponseFields _$AppResponseFieldsFromJson(Map<String, dynamic> json) =>
    AppResponseFields(
      asyncUrlEnrichEnabled: json['async_url_enrich_enabled'] as bool,
      autoTranslationEnabled: json['auto_translation_enabled'] as bool,
      fileUploadConfig: FileUploadConfig.fromJson(
        json['file_upload_config'] as Map<String, dynamic>,
      ),
      id: (json['id'] as num).toInt(),
      imageUploadConfig: FileUploadConfig.fromJson(
        json['image_upload_config'] as Map<String, dynamic>,
      ),
      name: json['name'] as String,
      placement: json['placement'] as String,
    );

Map<String, dynamic> _$AppResponseFieldsToJson(AppResponseFields instance) =>
    <String, dynamic>{
      'async_url_enrich_enabled': instance.asyncUrlEnrichEnabled,
      'auto_translation_enabled': instance.autoTranslationEnabled,
      'file_upload_config': instance.fileUploadConfig.toJson(),
      'id': instance.id,
      'image_upload_config': instance.imageUploadConfig.toJson(),
      'name': instance.name,
      'placement': instance.placement,
    };
