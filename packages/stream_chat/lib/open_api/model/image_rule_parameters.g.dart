// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageRuleParameters _$ImageRuleParametersFromJson(Map<String, dynamic> json) =>
    ImageRuleParameters(
      harmLabels: (json['harm_labels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      minConfidence: (json['min_confidence'] as num?)?.toDouble(),
      threshold: (json['threshold'] as num?)?.toInt(),
      timeWindow: json['time_window'] as String?,
    );

Map<String, dynamic> _$ImageRuleParametersToJson(
  ImageRuleParameters instance,
) => <String, dynamic>{
  'harm_labels': instance.harmLabels,
  'min_confidence': instance.minConfidence,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
