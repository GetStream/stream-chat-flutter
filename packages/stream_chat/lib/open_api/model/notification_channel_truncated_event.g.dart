// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_channel_truncated_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationChannelTruncatedEvent _$NotificationChannelTruncatedEventFromJson(
  Map<String, dynamic> json,
) => NotificationChannelTruncatedEvent(
  channel: ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
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
  groupedUnreadChannels: (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationChannelTruncatedEventToJson(
  NotificationChannelTruncatedEvent instance,
) => <String, dynamic>{
  'channel': instance.channel.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'message': instance.message?.toJson(),
  'message_id': instance.messageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
