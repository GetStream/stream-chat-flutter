// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_thread_message_new_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationThreadMessageNewEvent _$NotificationThreadMessageNewEventFromJson(
  Map<String, dynamic> json,
) => NotificationThreadMessageNewEvent(
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
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  parentAuthor: json['parent_author'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  threadId: json['thread_id'] as String,
  threadParticipants: (json['thread_participants'] as List<dynamic>?)
      ?.map((e) => UserResponseCommonFields.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
  unreadThreadMessages: (json['unread_thread_messages'] as num?)?.toInt(),
  unreadThreads: (json['unread_threads'] as num?)?.toInt(),
  watcherCount: (json['watcher_count'] as num).toInt(),
);

Map<String, dynamic> _$NotificationThreadMessageNewEventToJson(
  NotificationThreadMessageNewEvent instance,
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
  'message': instance.message.toJson(),
  'message_id': instance.messageId,
  'parent_author': instance.parentAuthor,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'thread_id': instance.threadId,
  'thread_participants': instance.threadParticipants?.map((e) => e.toJson()).toList(),
  'type': instance.type,
  'unread_thread_messages': instance.unreadThreadMessages,
  'unread_threads': instance.unreadThreads,
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
