// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_text_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AITextConfig _$AITextConfigFromJson(Map<String, dynamic> json) => AITextConfig(
  async: json['async'] as bool?,
  enabled: json['enabled'] as bool,
  profile: json['profile'] as String,
  rules: (json['rules'] as List<dynamic>)
      .map((e) => BodyguardRule.fromJson(e as Map<String, dynamic>))
      .toList(),
  severityRules: (json['severity_rules'] as List<dynamic>)
      .map((e) => BodyguardSeverityRule.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AITextConfigToJson(AITextConfig instance) =>
    <String, dynamic>{
      'async': instance.async,
      'enabled': instance.enabled,
      'profile': instance.profile,
      'rules': instance.rules.map((e) => e.toJson()).toList(),
      'severity_rules': instance.severityRules.map((e) => e.toJson()).toList(),
    };
