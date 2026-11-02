// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bodyguard_severity_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyguardSeverityRule _$BodyguardSeverityRuleFromJson(
  Map<String, dynamic> json,
) => BodyguardSeverityRule(
  action: json['action'] as BodyguardSeverityRuleAction,
  severity: json['severity'] as BodyguardSeverityRuleSeverity,
);

Map<String, dynamic> _$BodyguardSeverityRuleToJson(
  BodyguardSeverityRule instance,
) => <String, dynamic>{
  'action': instance.action,
  'severity': instance.severity,
};
