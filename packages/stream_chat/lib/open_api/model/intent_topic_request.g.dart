// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intent_topic_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntentTopicRequest _$IntentTopicRequestFromJson(Map<String, dynamic> json) => IntentTopicRequest(
  analysisCooldownSeconds: (json['analysis_cooldown_seconds'] as num?)?.toInt(),
  description: json['description'] as String?,
  enabled: json['enabled'] as bool?,
  label: json['label'] as String,
  maxCapturedItems: (json['max_captured_items'] as num?)?.toInt(),
  refireCooldownSeconds: (json['refire_cooldown_seconds'] as num?)?.toInt(),
  scoreThreshold: (json['score_threshold'] as num?)?.toDouble(),
);

Map<String, dynamic> _$IntentTopicRequestToJson(IntentTopicRequest instance) => <String, dynamic>{
  'analysis_cooldown_seconds': instance.analysisCooldownSeconds,
  'description': instance.description,
  'enabled': instance.enabled,
  'label': instance.label,
  'max_captured_items': instance.maxCapturedItems,
  'refire_cooldown_seconds': instance.refireCooldownSeconds,
  'score_threshold': instance.scoreThreshold,
};
