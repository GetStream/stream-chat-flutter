// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertConfigResponse _$UpsertConfigResponseFromJson(
  Map<String, dynamic> json,
) => UpsertConfigResponse(
  config: json['config'] == null
      ? null
      : ConfigResponse.fromJson(json['config'] as Map<String, dynamic>),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$UpsertConfigResponseToJson(
  UpsertConfigResponse instance,
) => <String, dynamic>{
  'config': instance.config?.toJson(),
  'duration': instance.duration,
};
