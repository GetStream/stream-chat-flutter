// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_audio_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIAudioConfigRequest _$AIAudioConfigRequestFromJson(
  Map<String, dynamic> json,
) => AIAudioConfigRequest(
  aiTextConfig: json['ai_text_config'] == null
      ? null
      : AITextConfig.fromJson(json['ai_text_config'] as Map<String, dynamic>),
  llmConfig: json['llm_config'] == null ? null : LLMConfig.fromJson(json['llm_config'] as Map<String, dynamic>),
  profile: json['profile'] as String?,
  rules: (json['rules'] as List<dynamic>?)?.map((e) => BodyguardRule.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$AIAudioConfigRequestToJson(
  AIAudioConfigRequest instance,
) => <String, dynamic>{
  'ai_text_config': instance.aiTextConfig?.toJson(),
  'llm_config': instance.llmConfig?.toJson(),
  'profile': instance.profile,
  'rules': instance.rules?.map((e) => e.toJson()).toList(),
};
