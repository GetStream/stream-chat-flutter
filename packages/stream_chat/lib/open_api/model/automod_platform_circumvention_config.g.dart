// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automod_platform_circumvention_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomodPlatformCircumventionConfig _$AutomodPlatformCircumventionConfigFromJson(
  Map<String, dynamic> json,
) => AutomodPlatformCircumventionConfig(
  async: json['async'] as bool?,
  enabled: json['enabled'] as bool,
  rules: (json['rules'] as List<dynamic>)
      .map((e) => AutomodRule.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AutomodPlatformCircumventionConfigToJson(
  AutomodPlatformCircumventionConfig instance,
) => <String, dynamic>{
  'async': instance.async,
  'enabled': instance.enabled,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
};
