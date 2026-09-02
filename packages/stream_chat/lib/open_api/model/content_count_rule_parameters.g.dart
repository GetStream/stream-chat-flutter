// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_count_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentCountRuleParameters _$ContentCountRuleParametersFromJson(
  Map<String, dynamic> json,
) => ContentCountRuleParameters(
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$ContentCountRuleParametersToJson(
  ContentCountRuleParameters instance,
) => <String, dynamic>{
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
