// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flood_similar_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloodSimilarRuleParameters _$FloodSimilarRuleParametersFromJson(
  Map<String, dynamic> json,
) => FloodSimilarRuleParameters(
  allowlist: (json['allowlist'] as List<dynamic>?)?.map((e) => e as String).toList(),
  similarityDistance: (json['similarity_distance'] as num?)?.toInt(),
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$FloodSimilarRuleParametersToJson(
  FloodSimilarRuleParameters instance,
) => <String, dynamic>{
  'allowlist': instance.allowlist,
  'similarity_distance': instance.similarityDistance,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
