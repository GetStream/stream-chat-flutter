// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_video_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIVideoConfigRequest _$AIVideoConfigRequestFromJson(
  Map<String, dynamic> json,
) => AIVideoConfigRequest(
  async: json['async'] as bool?,
  enabled: json['enabled'] as bool?,
  rules: (json['rules'] as List<dynamic>?)?.map((e) => AWSRekognitionRule.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$AIVideoConfigRequestToJson(
  AIVideoConfigRequest instance,
) => <String, dynamic>{
  'async': instance.async,
  'enabled': instance.enabled,
  'rules': instance.rules?.map((e) => e.toJson()).toList(),
};
