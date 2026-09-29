// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harm_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HarmConfig _$HarmConfigFromJson(Map<String, dynamic> json) => HarmConfig(
  actionSequences: (json['action_sequences'] as List<dynamic>)
      .map((e) => ActionSequence.fromJson(e as Map<String, dynamic>))
      .toList(),
  cooldownPeriod: (json['cooldown_period'] as num).toInt(),
  harmTypes: (json['harm_types'] as List<dynamic>).map((e) => e as String).toList(),
  severity: (json['severity'] as num).toInt(),
  threshold: (json['threshold'] as num).toInt(),
);

Map<String, dynamic> _$HarmConfigToJson(
  HarmConfig instance,
) => <String, dynamic>{
  'action_sequences': instance.actionSequences.map((e) => e.toJson()).toList(),
  'cooldown_period': instance.cooldownPeriod,
  'harm_types': instance.harmTypes,
  'severity': instance.severity,
  'threshold': instance.threshold,
};
