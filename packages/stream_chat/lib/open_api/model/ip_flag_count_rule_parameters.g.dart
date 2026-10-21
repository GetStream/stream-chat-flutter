// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_flag_count_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPFlagCountRuleParameters _$IPFlagCountRuleParametersFromJson(
  Map<String, dynamic> json,
) => IPFlagCountRuleParameters(
  harmLabels: (json['harm_labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
  severity: json['severity'] as String?,
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$IPFlagCountRuleParametersToJson(
  IPFlagCountRuleParameters instance,
) => <String, dynamic>{
  'harm_labels': instance.harmLabels,
  'severity': instance.severity,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
