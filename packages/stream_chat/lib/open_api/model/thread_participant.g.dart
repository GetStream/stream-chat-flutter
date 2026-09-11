// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadParticipant _$ThreadParticipantFromJson(Map<String, dynamic> json) => ThreadParticipant(
  channelCid: json['channel_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  lastReadAt: const StreamDateTimeConverter().fromJson(
    json['last_read_at'] as Object,
  ),
  lastThreadMessageAt: _$JsonConverterFromJson<Object, DateTime>(
    json['last_thread_message_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  leftThreadAt: _$JsonConverterFromJson<Object, DateTime>(
    json['left_thread_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  threadId: json['thread_id'] as String?,
  user: json['user'] == null ? null : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$ThreadParticipantToJson(
  ThreadParticipant instance,
) => <String, dynamic>{
  'channel_cid': instance.channelCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'last_read_at': const StreamDateTimeConverter().toJson(instance.lastReadAt),
  'last_thread_message_at': _$JsonConverterToJson<Object, DateTime>(
    instance.lastThreadMessageAt,
    const StreamDateTimeConverter().toJson,
  ),
  'left_thread_at': _$JsonConverterToJson<Object, DateTime>(
    instance.leftThreadAt,
    const StreamDateTimeConverter().toJson,
  ),
  'thread_id': instance.threadId,
  'user': instance.user?.toJson(),
  'user_id': instance.userId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
