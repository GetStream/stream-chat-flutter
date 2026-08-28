// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flood_identical_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloodIdenticalRuleParameters _$FloodIdenticalRuleParametersFromJson(
  Map<String, dynamic> json,
) => FloodIdenticalRuleParameters(
  allowlist: (json['allowlist'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$FloodIdenticalRuleParametersToJson(
  FloodIdenticalRuleParameters instance,
) => <String, dynamic>{
  'allowlist': instance.allowlist,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
