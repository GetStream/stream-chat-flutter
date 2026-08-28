// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flood_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloodConfig _$FloodConfigFromJson(Map<String, dynamic> json) => FloodConfig(
  allowlist: (json['allowlist'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  identical_: json['identical'] == null
      ? null
      : FloodIdenticalConfig.fromJson(
          json['identical'] as Map<String, dynamic>,
        ),
  similar: json['similar'] == null
      ? null
      : FloodSimilarConfig.fromJson(json['similar'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FloodConfigToJson(FloodConfig instance) =>
    <String, dynamic>{
      'allowlist': instance.allowlist,
      'identical': instance.identical_?.toJson(),
      'similar': instance.similar?.toJson(),
    };
