// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_moderation_configs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryModerationConfigsResponse _$QueryModerationConfigsResponseFromJson(
  Map<String, dynamic> json,
) => QueryModerationConfigsResponse(
  configs: (json['configs'] as List<dynamic>)
      .map((e) => ConfigResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  duration: json['duration'] as String,
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$QueryModerationConfigsResponseToJson(
  QueryModerationConfigsResponse instance,
) => <String, dynamic>{
  'configs': instance.configs.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
  'next': instance.next,
  'prev': instance.prev,
};
