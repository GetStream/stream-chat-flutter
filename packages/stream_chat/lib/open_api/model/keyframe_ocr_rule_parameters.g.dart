// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyframe_ocr_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeyframeOCRRuleParameters _$KeyframeOCRRuleParametersFromJson(
  Map<String, dynamic> json,
) => KeyframeOCRRuleParameters(
  harmLabels: (json['harm_labels'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$KeyframeOCRRuleParametersToJson(
  KeyframeOCRRuleParameters instance,
) => <String, dynamic>{
  'harm_labels': instance.harmLabels,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
