// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bodyguard_severity_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyguardSeverityRule _$BodyguardSeverityRuleFromJson(
  Map<String, dynamic> json,
) => BodyguardSeverityRule(
  action: BodyguardSeverityRuleAction.fromJson(json['action'] as String),
  severity: BodyguardSeverityRuleSeverity.fromJson(json['severity'] as String),
);

Map<String, dynamic> _$BodyguardSeverityRuleToJson(
  BodyguardSeverityRule instance,
) => <String, dynamic>{
  'action': instance.action.toJson(),
  'severity': instance.severity.toJson(),
};
