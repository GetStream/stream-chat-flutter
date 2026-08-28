// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_call_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationCallResponse _$ModerationCallResponseFromJson(
  Map<String, dynamic> json,
) => ModerationCallResponse(
  backstage: json['backstage'] as bool,
  blockedUserIds: (json['blocked_user_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  captioning: json['captioning'] as bool,
  channelCid: json['channel_cid'] as String?,
  cid: json['cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null
      ? null
      : UserResponse.fromJson(json['created_by'] as Map<String, dynamic>),
  currentSessionId: json['current_session_id'] as String,
  custom: json['custom'] as Map<String, dynamic>,
  endedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['ended_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  id: json['id'] as String,
  joinAheadTimeSeconds: (json['join_ahead_time_seconds'] as num?)?.toInt(),
  recording: json['recording'] as bool,
  routingNumber: json['routing_number'] as String?,
  startsAt: _$JsonConverterFromJson<Object, DateTime>(
    json['starts_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  transcribing: json['transcribing'] as bool,
  translating: json['translating'] as bool,
  type: json['type'] as String,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$ModerationCallResponseToJson(
  ModerationCallResponse instance,
) => <String, dynamic>{
  'backstage': instance.backstage,
  'blocked_user_ids': instance.blockedUserIds,
  'captioning': instance.captioning,
  'channel_cid': instance.channelCid,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy?.toJson(),
  'current_session_id': instance.currentSessionId,
  'custom': instance.custom,
  'ended_at': _$JsonConverterToJson<Object, DateTime>(
    instance.endedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'id': instance.id,
  'join_ahead_time_seconds': instance.joinAheadTimeSeconds,
  'recording': instance.recording,
  'routing_number': instance.routingNumber,
  'starts_at': _$JsonConverterToJson<Object, DateTime>(
    instance.startsAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'transcribing': instance.transcribing,
  'translating': instance.translating,
  'type': instance.type,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
