// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_mark_unread_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationMarkUnreadEvent _$NotificationMarkUnreadEventFromJson(
  Map<String, dynamic> json,
) => NotificationMarkUnreadEvent(
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
  firstUnreadMessageId: json['first_unread_message_id'] as String?,
  groupedUnreadChannels:
      (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
  lastReadAt: _$JsonConverterFromJson<Object, DateTime>(
    json['last_read_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  lastReadMessageId: json['last_read_message_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  threadId: json['thread_id'] as String?,
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
  unreadMessages: (json['unread_messages'] as num?)?.toInt(),
  unreadThreadMessages: (json['unread_thread_messages'] as num?)?.toInt(),
  unreadThreads: (json['unread_threads'] as num?)?.toInt(),
  user: json['user'] == null
      ? null
      : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationMarkUnreadEventToJson(
  NotificationMarkUnreadEvent instance,
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
  'first_unread_message_id': instance.firstUnreadMessageId,
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'last_read_at': _$JsonConverterToJson<Object, DateTime>(
    instance.lastReadAt,
    const StreamDateTimeConverter().toJson,
  ),
  'last_read_message_id': instance.lastReadMessageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'thread_id': instance.threadId,
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
  'unread_messages': instance.unreadMessages,
  'unread_thread_messages': instance.unreadThreadMessages,
  'unread_threads': instance.unreadThreads,
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
