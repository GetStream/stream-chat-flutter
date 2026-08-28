// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_builder_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleBuilderConfig _$RuleBuilderConfigFromJson(Map<String, dynamic> json) =>
    RuleBuilderConfig(
      async: json['async'] as bool?,
      rules: (json['rules'] as List<dynamic>?)
          ?.map((e) => RuleBuilderRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RuleBuilderConfigToJson(RuleBuilderConfig instance) =>
    <String, dynamic>{
      'async': instance.async,
      'rules': instance.rules?.map((e) => e.toJson()).toList(),
    };
