// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyframe_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyframeRuleParameters _$KeyframeRuleParametersFromJson(
  Map<String, dynamic> json,
) => KeyframeRuleParameters(
  harmLabels: (json['harm_labels'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  minConfidence: (json['min_confidence'] as num?)?.toDouble(),
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$KeyframeRuleParametersToJson(
  KeyframeRuleParameters instance,
) => <String, dynamic>{
  'harm_labels': instance.harmLabels,
  'min_confidence': instance.minConfidence,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
