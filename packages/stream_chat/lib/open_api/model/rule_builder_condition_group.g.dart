// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_builder_condition_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleBuilderConditionGroup _$RuleBuilderConditionGroupFromJson(
  Map<String, dynamic> json,
) => RuleBuilderConditionGroup(
  conditions: (json['conditions'] as List<dynamic>?)
      ?.map((e) => RuleBuilderCondition.fromJson(e as Map<String, dynamic>))
      .toList(),
  logic: json['logic'] as String?,
);

Map<String, dynamic> _$RuleBuilderConditionGroupToJson(
  RuleBuilderConditionGroup instance,
) => <String, dynamic>{
  'conditions': instance.conditions?.map((e) => e.toJson()).toList(),
  'logic': instance.logic,
};
