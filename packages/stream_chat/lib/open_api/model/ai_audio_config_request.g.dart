// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_audio_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIAudioConfigRequest _$AIAudioConfigRequestFromJson(
  Map<String, dynamic> json,
) => AIAudioConfigRequest(
  profile: json['profile'] as String?,
  rules: (json['rules'] as List<dynamic>?)?.map((e) => BodyguardRule.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$AIAudioConfigRequestToJson(
  AIAudioConfigRequest instance,
) => <String, dynamic>{
  'profile': instance.profile,
  'rules': instance.rules?.map((e) => e.toJson()).toList(),
};
