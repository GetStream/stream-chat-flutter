// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automod_toxicity_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomodToxicityConfig _$AutomodToxicityConfigFromJson(
  Map<String, dynamic> json,
) => AutomodToxicityConfig(
  async: json['async'] as bool?,
  enabled: json['enabled'] as bool,
  rules: (json['rules'] as List<dynamic>).map((e) => AutomodRule.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$AutomodToxicityConfigToJson(
  AutomodToxicityConfig instance,
) => <String, dynamic>{
  'async': instance.async,
  'enabled': instance.enabled,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
};
