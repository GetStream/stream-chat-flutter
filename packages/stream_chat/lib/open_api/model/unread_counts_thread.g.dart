// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_counts_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadCountsThread _$UnreadCountsThreadFromJson(Map<String, dynamic> json) =>
    UnreadCountsThread(
      lastRead: const StreamDateTimeConverter().fromJson(
        json['last_read'] as Object,
      ),
      lastReadMessageId: json['last_read_message_id'] as String,
      parentMessageId: json['parent_message_id'] as String,
      unreadCount: (json['unread_count'] as num).toInt(),
    );

Map<String, dynamic> _$UnreadCountsThreadToJson(UnreadCountsThread instance) =>
    <String, dynamic>{
      'last_read': const StreamDateTimeConverter().toJson(instance.lastRead),
      'last_read_message_id': instance.lastReadMessageId,
      'parent_message_id': instance.parentMessageId,
      'unread_count': instance.unreadCount,
    };
