// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppEventResponse _$AppEventResponseFromJson(Map<String, dynamic> json) =>
    AppEventResponse(
      asyncUrlEnrichEnabled: json['async_url_enrich_enabled'] as bool?,
      autoTranslationEnabled: json['auto_translation_enabled'] as bool,
      fileUploadConfig: json['file_upload_config'] == null
          ? null
          : FileUploadConfig.fromJson(
              json['file_upload_config'] as Map<String, dynamic>,
            ),
      imageUploadConfig: json['image_upload_config'] == null
          ? null
          : FileUploadConfig.fromJson(
              json['image_upload_config'] as Map<String, dynamic>,
            ),
      name: json['name'] as String,
    );

Map<String, dynamic> _$AppEventResponseToJson(AppEventResponse instance) =>
    <String, dynamic>{
      'async_url_enrich_enabled': instance.asyncUrlEnrichEnabled,
      'auto_translation_enabled': instance.autoTranslationEnabled,
      'file_upload_config': instance.fileUploadConfig?.toJson(),
      'image_upload_config': instance.imageUploadConfig?.toJson(),
      'name': instance.name,
    };
