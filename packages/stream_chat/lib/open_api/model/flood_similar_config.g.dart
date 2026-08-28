// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flood_similar_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloodSimilarConfig _$FloodSimilarConfigFromJson(Map<String, dynamic> json) =>
    FloodSimilarConfig(
      action: json['action'] as String,
      enabled: json['enabled'] as bool,
      similarityDistance: (json['similarity_distance'] as num).toInt(),
      threshold: (json['threshold'] as num).toInt(),
      timeWindow: json['time_window'] as String,
    );

Map<String, dynamic> _$FloodSimilarConfigToJson(FloodSimilarConfig instance) =>
    <String, dynamic>{
      'action': instance.action,
      'enabled': instance.enabled,
      'similarity_distance': instance.similarityDistance,
      'threshold': instance.threshold,
      'time_window': instance.timeWindow,
    };
