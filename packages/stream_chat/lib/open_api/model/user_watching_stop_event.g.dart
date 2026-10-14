// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_watching_stop_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWatchingStopEvent _$UserWatchingStopEventFromJson(
  Map<String, dynamic> json,
) => UserWatchingStopEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
  watcherCount: (json['watcher_count'] as num).toInt(),
);

Map<String, dynamic> _$UserWatchingStopEventToJson(
  UserWatchingStopEvent instance,
) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
  'watcher_count': instance.watcherCount,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
