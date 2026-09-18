// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'velocity_filter_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VelocityFilterConfig _$VelocityFilterConfigFromJson(
  Map<String, dynamic> json,
) => VelocityFilterConfig(
  advancedFilters: json['advanced_filters'] as bool,
  async: json['async'] as bool?,
  cascadingActions: json['cascading_actions'] as bool,
  cidsPerUser: (json['cids_per_user'] as num).toInt(),
  enabled: json['enabled'] as bool,
  firstMessageOnly: json['first_message_only'] as bool,
  rules: (json['rules'] as List<dynamic>)
      .map((e) => VelocityFilterConfigRule.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VelocityFilterConfigToJson(
  VelocityFilterConfig instance,
) => <String, dynamic>{
  'advanced_filters': instance.advancedFilters,
  'async': instance.async,
  'cascading_actions': instance.cascadingActions,
  'cids_per_user': instance.cidsPerUser,
  'enabled': instance.enabled,
  'first_message_only': instance.firstMessageOnly,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
};
