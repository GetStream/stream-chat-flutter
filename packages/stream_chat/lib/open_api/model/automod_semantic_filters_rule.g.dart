// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automod_semantic_filters_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomodSemanticFiltersRule _$AutomodSemanticFiltersRuleFromJson(
  Map<String, dynamic> json,
) => AutomodSemanticFiltersRule(
  action: AutomodSemanticFiltersRuleAction.fromJson(json['action'] as String),
  name: json['name'] as String,
  threshold: (json['threshold'] as num).toDouble(),
);

Map<String, dynamic> _$AutomodSemanticFiltersRuleToJson(
  AutomodSemanticFiltersRule instance,
) => <String, dynamic>{
  'action': instance.action.toJson(),
  'name': instance.name,
  'threshold': instance.threshold,
};
