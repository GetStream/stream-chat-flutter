// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'closed_caption_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClosedCaptionRuleParameters _$ClosedCaptionRuleParametersFromJson(
  Map<String, dynamic> json,
) => ClosedCaptionRuleParameters(
  harmLabels: (json['harm_labels'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  llmHarmLabels: (json['llm_harm_labels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  severity: json['severity'] as String?,
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$ClosedCaptionRuleParametersToJson(
  ClosedCaptionRuleParameters instance,
) => <String, dynamic>{
  'harm_labels': instance.harmLabels,
  'llm_harm_labels': instance.llmHarmLabels,
  'severity': instance.severity,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
