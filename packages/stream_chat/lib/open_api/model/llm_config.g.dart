// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LLMConfig _$LLMConfigFromJson(Map<String, dynamic> json) => LLMConfig(
  appContext: json['app_context'] as String?,
  async: json['async'] as bool?,
  enabled: json['enabled'] as bool,
  rules: (json['rules'] as List<dynamic>)
      .map((e) => LLMRule.fromJson(e as Map<String, dynamic>))
      .toList(),
  severityDescriptions: (json['severity_descriptions'] as Map<String, dynamic>?)
      ?.map((k, e) => MapEntry(k, e as String)),
);

Map<String, dynamic> _$LLMConfigToJson(LLMConfig instance) => <String, dynamic>{
  'app_context': instance.appContext,
  'async': instance.async,
  'enabled': instance.enabled,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
  'severity_descriptions': instance.severityDescriptions,
};
