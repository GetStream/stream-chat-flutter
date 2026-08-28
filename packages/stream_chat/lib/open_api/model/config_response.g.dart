// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigResponse _$ConfigResponseFromJson(
  Map<String, dynamic> json,
) => ConfigResponse(
  aiAudioConfig: json['ai_audio_config'] == null
      ? null
      : AIAudioConfigResponse.fromJson(
          json['ai_audio_config'] as Map<String, dynamic>,
        ),
  aiImageConfig: json['ai_image_config'] == null
      ? null
      : AIImageConfig.fromJson(json['ai_image_config'] as Map<String, dynamic>),
  aiImageLabelDefinitions: (json['ai_image_label_definitions'] as List<dynamic>?)
      ?.map(
        (e) => AIImageLabelDefinition.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  aiImageSubclassifications: (json['ai_image_subclassifications'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
  aiTextConfig: json['ai_text_config'] == null
      ? null
      : AITextConfig.fromJson(json['ai_text_config'] as Map<String, dynamic>),
  aiVideoConfig: json['ai_video_config'] == null
      ? null
      : AIVideoConfig.fromJson(json['ai_video_config'] as Map<String, dynamic>),
  async: json['async'] as bool,
  automodPlatformCircumventionConfig: json['automod_platform_circumvention_config'] == null
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
  availableBodyguardProfiles: (json['available_bodyguard_profiles'] as List<dynamic>?)
      ?.map(
        (e) => BodyguardProfileSummary.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  blockListConfig: json['block_list_config'] == null
      ? null
      : BlockListConfig.fromJson(
          json['block_list_config'] as Map<String, dynamic>,
        ),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  floodConfig: json['flood_config'] == null ? null : FloodConfig.fromJson(json['flood_config'] as Map<String, dynamic>),
  key: json['key'] as String,
  llmConfig: json['llm_config'] == null ? null : LLMConfig.fromJson(json['llm_config'] as Map<String, dynamic>),
  supportedVideoCallHarmTypes: (json['supported_video_call_harm_types'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  team: json['team'] as String,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
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

Map<String, dynamic> _$ConfigResponseToJson(ConfigResponse instance) => <String, dynamic>{
  'ai_audio_config': instance.aiAudioConfig?.toJson(),
  'ai_image_config': instance.aiImageConfig?.toJson(),
  'ai_image_label_definitions': instance.aiImageLabelDefinitions?.map((e) => e.toJson()).toList(),
  'ai_image_subclassifications': instance.aiImageSubclassifications,
  'ai_text_config': instance.aiTextConfig?.toJson(),
  'ai_video_config': instance.aiVideoConfig?.toJson(),
  'async': instance.async,
  'automod_platform_circumvention_config': instance.automodPlatformCircumventionConfig?.toJson(),
  'automod_semantic_filters_config': instance.automodSemanticFiltersConfig?.toJson(),
  'automod_toxicity_config': instance.automodToxicityConfig?.toJson(),
  'available_bodyguard_profiles': instance.availableBodyguardProfiles?.map((e) => e.toJson()).toList(),
  'block_list_config': instance.blockListConfig?.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'flood_config': instance.floodConfig?.toJson(),
  'key': instance.key,
  'llm_config': instance.llmConfig?.toJson(),
  'supported_video_call_harm_types': instance.supportedVideoCallHarmTypes,
  'team': instance.team,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'velocity_filter_config': instance.velocityFilterConfig?.toJson(),
  'video_call_rule_config': instance.videoCallRuleConfig?.toJson(),
};
