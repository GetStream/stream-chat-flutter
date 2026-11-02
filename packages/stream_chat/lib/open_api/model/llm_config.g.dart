// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LLMConfig _$LLMConfigFromJson(Map<String, dynamic> json) => LLMConfig(
  appContext: json['app_context'] as String?,
  async: json['async'] as bool?,
  contextCustomKeys: (json['context_custom_keys'] as List<dynamic>?)?.map((e) => e as String).toList(),
  customKeysContextDescription: json['custom_keys_context_description'] as String?,
  enabled: json['enabled'] as bool,
  rules: (json['rules'] as List<dynamic>).map((e) => LLMRule.fromJson(e as Map<String, dynamic>)).toList(),
  severityDescriptions: (json['severity_descriptions'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$LLMConfigToJson(LLMConfig instance) => <String, dynamic>{
  'app_context': instance.appContext,
  'async': instance.async,
  'context_custom_keys': instance.contextCustomKeys,
  'custom_keys_context_description': instance.customKeysContextDescription,
  'enabled': instance.enabled,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
  'severity_descriptions': instance.severityDescriptions,
};
