// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockListRule _$BlockListRuleFromJson(Map<String, dynamic> json) => BlockListRule(
  action: BlockListRuleAction.fromJson(json['action'] as String),
  name: json['name'] as String,
  team: json['team'] as String,
);

Map<String, dynamic> _$BlockListRuleToJson(BlockListRule instance) => <String, dynamic>{
  'action': instance.action.toJson(),
  'name': instance.name,
  'team': instance.team,
};
