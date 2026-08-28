// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetConfigResponse _$GetConfigResponseFromJson(Map<String, dynamic> json) =>
    GetConfigResponse(
      config: json['config'] == null
          ? null
          : ConfigResponse.fromJson(json['config'] as Map<String, dynamic>),
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$GetConfigResponseToJson(GetConfigResponse instance) =>
    <String, dynamic>{
      'config': instance.config?.toJson(),
      'duration': instance.duration,
    };
