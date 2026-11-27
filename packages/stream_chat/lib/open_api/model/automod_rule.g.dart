// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automod_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomodRule _$AutomodRuleFromJson(Map<String, dynamic> json) => AutomodRule(
  action: json['action'] as ModerationAction,
  label: json['label'] as String,
  threshold: (json['threshold'] as num).toDouble(),
);

Map<String, dynamic> _$AutomodRuleToJson(AutomodRule instance) => <String, dynamic>{
  'action': instance.action,
  'label': instance.label,
  'threshold': instance.threshold,
};
