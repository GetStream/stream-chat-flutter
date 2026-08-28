// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertConfigRequest _$UpsertConfigRequestFromJson(
  Map<String, dynamic> json,
) => UpsertConfigRequest(
  aiAudioConfig: json['ai_audio_config'] == null
      ? null
      : AIAudioConfigRequest.fromJson(
          json['ai_audio_config'] as Map<String, dynamic>,
        ),
  aiImageConfig: json['ai_image_config'] == null
      ? null
      : AIImageConfig.fromJson(json['ai_image_config'] as Map<String, dynamic>),
  aiTextConfig: json['ai_text_config'] == null
      ? null
      : AITextConfig.fromJson(json['ai_text_config'] as Map<String, dynamic>),
  aiVideoConfig: json['ai_video_config'] == null
      ? null
      : AIVideoConfig.fromJson(json['ai_video_config'] as Map<String, dynamic>),
  async: json['async'] as bool?,
  automodPlatformCircumventionConfig:
      json['automod_platform_circumvention_config'] == null
      ? null
      : AutomodPlatformCircumventionConfig.fromJson(
          json['automod_platform_circumvention_config'] as Map<String, dynamic>,
        ),
  automodSemanticFiltersConfig: json['automod_semantic_filters_config'] == null
      ? null
      : AutomodSemanticFiltersConfig.fromJson(
          json['automod_semantic_filters_config'] as Map<String, dynamic>,
        ),
  automodToxicityConfig: json['automod_toxicity_config'] == null
      ? null
      : AutomodToxicityConfig.fromJson(
          json['automod_toxicity_config'] as Map<String, dynamic>,
        ),
  awsRekognitionConfig: json['aws_rekognition_config'] == null
      ? null
      : AIImageConfig.fromJson(
          json['aws_rekognition_config'] as Map<String, dynamic>,
        ),
  blockListConfig: json['block_list_config'] == null
      ? null
      : BlockListConfig.fromJson(
          json['block_list_config'] as Map<String, dynamic>,
        ),
  bodyguardConfig: json['bodyguard_config'] == null
      ? null
      : AITextConfig.fromJson(json['bodyguard_config'] as Map<String, dynamic>),
  floodConfig: json['flood_config'] == null
      ? null
      : FloodConfig.fromJson(json['flood_config'] as Map<String, dynamic>),
  googleVisionConfig: json['google_vision_config'] == null
      ? null
      : GoogleVisionConfig.fromJson(
          json['google_vision_config'] as Map<String, dynamic>,
        ),
  key: json['key'] as String,
  llmConfig: json['llm_config'] == null
      ? null
      : LLMConfig.fromJson(json['llm_config'] as Map<String, dynamic>),
  ruleBuilderConfig: json['rule_builder_config'] == null
      ? null
      : RuleBuilderConfig.fromJson(
          json['rule_builder_config'] as Map<String, dynamic>,
        ),
  team: json['team'] as String?,
  velocityFilterConfig: json['velocity_filter_config'] == null
      ? null
      : VelocityFilterConfig.fromJson(
          json['velocity_filter_config'] as Map<String, dynamic>,
        ),
  videoCallRuleConfig: json['video_call_rule_config'] == null
      ? null
      : VideoCallRuleConfig.fromJson(
          json['video_call_rule_config'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UpsertConfigRequestToJson(
  UpsertConfigRequest instance,
) => <String, dynamic>{
  'ai_audio_config': instance.aiAudioConfig?.toJson(),
  'ai_image_config': instance.aiImageConfig?.toJson(),
  'ai_text_config': instance.aiTextConfig?.toJson(),
  'ai_video_config': instance.aiVideoConfig?.toJson(),
  'async': instance.async,
  'automod_platform_circumvention_config': instance
      .automodPlatformCircumventionConfig
      ?.toJson(),
  'automod_semantic_filters_config': instance.automodSemanticFiltersConfig
      ?.toJson(),
  'automod_toxicity_config': instance.automodToxicityConfig?.toJson(),
  'aws_rekognition_config': instance.awsRekognitionConfig?.toJson(),
  'block_list_config': instance.blockListConfig?.toJson(),
  'bodyguard_config': instance.bodyguardConfig?.toJson(),
  'flood_config': instance.floodConfig?.toJson(),
  'google_vision_config': instance.googleVisionConfig?.toJson(),
  'key': instance.key,
  'llm_config': instance.llmConfig?.toJson(),
  'rule_builder_config': instance.ruleBuilderConfig?.toJson(),
  'team': instance.team,
  'velocity_filter_config': instance.velocityFilterConfig?.toJson(),
  'video_call_rule_config': instance.videoCallRuleConfig?.toJson(),
};
