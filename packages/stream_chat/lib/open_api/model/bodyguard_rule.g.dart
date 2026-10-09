// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bodyguard_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyguardRule _$BodyguardRuleFromJson(Map<String, dynamic> json) => BodyguardRule(
  action: BodyguardRuleAction.fromJson(json['action'] as String),
  label: json['label'] as String,
  severityRules: (json['severity_rules'] as List<dynamic>)
      .map((e) => BodyguardSeverityRule.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BodyguardRuleToJson(BodyguardRule instance) => <String, dynamic>{
  'action': instance.action.toJson(),
  'label': instance.label,
  'severity_rules': instance.severityRules.map((e) => e.toJson()).toList(),
};
