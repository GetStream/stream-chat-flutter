// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_delivered_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDeliveredEvent _$MessageDeliveredEventFromJson(
  Map<String, dynamic> json,
) => MessageDeliveredEvent(
  channel: json['channel'] == null
      ? null
      : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  channelCustom: json['channel_custom'] as Map<String, dynamic>?,
  channelId: json['channel_id'] as String?,
  channelMemberCount: (json['channel_member_count'] as num?)?.toInt(),
  channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  lastDeliveredAt: json['last_delivered_at'] as String?,
  lastDeliveredMessageId: json['last_delivered_message_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null
      ? null
      : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageDeliveredEventToJson(
  MessageDeliveredEvent instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'last_delivered_at': instance.lastDeliveredAt,
  'last_delivered_message_id': instance.lastDeliveredMessageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
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
