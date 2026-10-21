// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_call_rule_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoCallRuleConfig _$VideoCallRuleConfigFromJson(Map<String, dynamic> json) => VideoCallRuleConfig(
  flagAllLabels: json['flag_all_labels'] as bool,
  flaggedLabels: (json['flagged_labels'] as List<dynamic>).map((e) => e as String).toList(),
  rules: (json['rules'] as List<dynamic>).map((e) => HarmConfig.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$VideoCallRuleConfigToJson(
  VideoCallRuleConfig instance,
) => <String, dynamic>{
  'flag_all_labels': instance.flagAllLabels,
  'flagged_labels': instance.flaggedLabels,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
};
