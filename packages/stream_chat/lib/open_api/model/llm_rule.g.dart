// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LLMRule _$LLMRuleFromJson(Map<String, dynamic> json) => LLMRule(
  action: LLMRuleAction.fromJson(json['action'] as String),
  description: json['description'] as String,
  label: json['label'] as String,
  severityRules: (json['severity_rules'] as List<dynamic>)
      .map((e) => BodyguardSeverityRule.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LLMRuleToJson(LLMRule instance) => <String, dynamic>{
  'action': instance.action.toJson(),
  'description': instance.description,
  'label': instance.label,
  'severity_rules': instance.severityRules.map((e) => e.toJson()).toList(),
};
