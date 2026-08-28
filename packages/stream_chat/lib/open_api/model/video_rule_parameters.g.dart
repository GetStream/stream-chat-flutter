// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoRuleParameters _$VideoRuleParametersFromJson(Map<String, dynamic> json) =>
    VideoRuleParameters(
      harmLabels: (json['harm_labels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      threshold: (json['threshold'] as num?)?.toInt(),
      timeWindow: json['time_window'] as String?,
    );

Map<String, dynamic> _$VideoRuleParametersToJson(
  VideoRuleParameters instance,
) => <String, dynamic>{
  'harm_labels': instance.harmLabels,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
