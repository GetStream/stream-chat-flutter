// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_audio_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIAudioConfigResponse _$AIAudioConfigResponseFromJson(
  Map<String, dynamic> json,
) => AIAudioConfigResponse(
  enabled: json['enabled'] as bool,
  profile: json['profile'] as String,
  rules: (json['rules'] as List<dynamic>).map((e) => BodyguardRule.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$AIAudioConfigResponseToJson(
  AIAudioConfigResponse instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'profile': instance.profile,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
};
