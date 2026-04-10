// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadCountsChannel _$UnreadCountsChannelFromJson(Map<String, dynamic> json) => UnreadCountsChannel(
  channelId: json['channel_id'] as String,
  unreadCount: (json['unread_count'] as num).toInt(),
  lastRead: DateTime.parse(json['last_read'] as String),
);

Map<String, dynamic> _$UnreadCountsChannelToJson(UnreadCountsChannel instance) => <String, dynamic>{
  'channel_id': instance.channelId,
  'unread_count': instance.unreadCount,
  'last_read': instance.lastRead.toIso8601String(),
};

UnreadCountsThread _$UnreadCountsThreadFromJson(Map<String, dynamic> json) => UnreadCountsThread(
  unreadCount: (json['unread_count'] as num).toInt(),
  lastRead: DateTime.parse(json['last_read'] as String),
  lastReadMessageId: json['last_read_message_id'] as String,
  parentMessageId: json['parent_message_id'] as String,
);

Map<String, dynamic> _$UnreadCountsThreadToJson(UnreadCountsThread instance) => <String, dynamic>{
  'unread_count': instance.unreadCount,
  'last_read': instance.lastRead.toIso8601String(),
  'last_read_message_id': instance.lastReadMessageId,
  'parent_message_id': instance.parentMessageId,
};

UnreadCountsChannelType _$UnreadCountsChannelTypeFromJson(Map<String, dynamic> json) => UnreadCountsChannelType(
  channelType: json['channel_type'] as String,
  channelCount: (json['channel_count'] as num).toInt(),
  unreadCount: (json['unread_count'] as num).toInt(),
);

Map<String, dynamic> _$UnreadCountsChannelTypeToJson(UnreadCountsChannelType instance) => <String, dynamic>{
  'channel_type': instance.channelType,
  'channel_count': instance.channelCount,
  'unread_count': instance.unreadCount,
};
