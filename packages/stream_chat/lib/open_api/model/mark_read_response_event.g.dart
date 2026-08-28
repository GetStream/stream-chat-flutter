// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_read_response_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkReadResponseEvent _$MarkReadResponseEventFromJson(
  Map<String, dynamic> json,
) => MarkReadResponseEvent(
  channel: json['channel'] == null
      ? null
      : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  channelId: json['channel_id'] as String,
  channelLastMessageAt: _$JsonConverterFromJson<Object, DateTime>(
    json['channel_last_message_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  channelType: json['channel_type'] as String,
  cid: json['cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  lastReadMessageId: json['last_read_message_id'] as String?,
  team: json['team'] as String?,
  thread: json['thread'] == null
      ? null
      : ThreadResponse.fromJson(json['thread'] as Map<String, dynamic>),
  type: json['type'] as String,
  user: json['user'] == null
      ? null
      : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MarkReadResponseEventToJson(
  MarkReadResponseEvent instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'channel_id': instance.channelId,
  'channel_last_message_at': _$JsonConverterToJson<Object, DateTime>(
    instance.channelLastMessageAt,
    const StreamDateTimeConverter().toJson,
  ),
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'last_read_message_id': instance.lastReadMessageId,
  'team': instance.team,
  'thread': instance.thread?.toJson(),
  'type': instance.type,
  'user': instance.user?.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
