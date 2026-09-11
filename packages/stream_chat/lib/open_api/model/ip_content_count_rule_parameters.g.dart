// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_content_count_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPContentCountRuleParameters _$IPContentCountRuleParametersFromJson(
  Map<String, dynamic> json,
) => IPContentCountRuleParameters(
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$IPContentCountRuleParametersToJson(
  IPContentCountRuleParameters instance,
) => <String, dynamic>{
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
