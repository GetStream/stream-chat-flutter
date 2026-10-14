// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automod_semantic_filters_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomodSemanticFiltersConfig _$AutomodSemanticFiltersConfigFromJson(
  Map<String, dynamic> json,
) => AutomodSemanticFiltersConfig(
  async: json['async'] as bool?,
  enabled: json['enabled'] as bool,
  rules: (json['rules'] as List<dynamic>)
      .map(
        (e) => AutomodSemanticFiltersRule.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$AutomodSemanticFiltersConfigToJson(
  AutomodSemanticFiltersConfig instance,
) => <String, dynamic>{
  'async': instance.async,
  'enabled': instance.enabled,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
};
