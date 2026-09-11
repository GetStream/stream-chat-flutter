// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flood_identical_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloodIdenticalConfig _$FloodIdenticalConfigFromJson(
  Map<String, dynamic> json,
) => FloodIdenticalConfig(
  action: json['action'] as String,
  enabled: json['enabled'] as bool,
  threshold: (json['threshold'] as num).toInt(),
  timeWindow: json['time_window'] as String,
);

Map<String, dynamic> _$FloodIdenticalConfigToJson(
  FloodIdenticalConfig instance,
) => <String, dynamic>{
  'action': instance.action,
  'enabled': instance.enabled,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
