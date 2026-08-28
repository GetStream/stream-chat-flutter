// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockListConfig _$BlockListConfigFromJson(Map<String, dynamic> json) =>
    BlockListConfig(
      async: json['async'] as bool?,
      enabled: json['enabled'] as bool,
      matchSubstring: json['match_substring'] as bool?,
      rules: (json['rules'] as List<dynamic>)
          .map((e) => BlockListRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockListConfigToJson(BlockListConfig instance) =>
    <String, dynamic>{
      'async': instance.async,
      'enabled': instance.enabled,
      'match_substring': instance.matchSubstring,
      'rules': instance.rules.map((e) => e.toJson()).toList(),
    };
