// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_video_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIVideoConfigResponse _$AIVideoConfigResponseFromJson(
  Map<String, dynamic> json,
) => AIVideoConfigResponse(
  async: json['async'] as bool?,
  enabled: json['enabled'] as bool,
  rules: (json['rules'] as List<dynamic>).map((e) => AWSRekognitionRule.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$AIVideoConfigResponseToJson(
  AIVideoConfigResponse instance,
) => <String, dynamic>{
  'async': instance.async,
  'enabled': instance.enabled,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
};
