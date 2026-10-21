// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flood_identical_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloodIdenticalRuleParameters _$FloodIdenticalRuleParametersFromJson(
  Map<String, dynamic> json,
) => FloodIdenticalRuleParameters(
  allowlist: (json['allowlist'] as List<dynamic>?)?.map((e) => e as String).toList(),
  minTextLength: (json['min_text_length'] as num?)?.toInt(),
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
  trackAcrossUsers: json['track_across_users'] as bool?,
);

Map<String, dynamic> _$FloodIdenticalRuleParametersToJson(
  FloodIdenticalRuleParameters instance,
) => <String, dynamic>{
  'allowlist': instance.allowlist,
  'min_text_length': instance.minTextLength,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
  'track_across_users': instance.trackAcrossUsers,
};
