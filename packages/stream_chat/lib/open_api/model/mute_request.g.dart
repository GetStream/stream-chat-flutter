// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteRequest _$MuteRequestFromJson(Map<String, dynamic> json) => MuteRequest(
  targetIds: (json['target_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  timeout: (json['timeout'] as num?)?.toInt(),
);

Map<String, dynamic> _$MuteRequestToJson(MuteRequest instance) =>
    <String, dynamic>{
      'target_ids': instance.targetIds,
      'timeout': instance.timeout,
    };
