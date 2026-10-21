// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Read _$ReadFromJson(Map<String, dynamic> json) => Read(
  lastRead: DateTime.parse(json['last_read'] as String),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  lastReadMessageId: json['last_read_message_id'] as String?,
  unreadMessages: (json['unread_messages'] as num?)?.toInt(),
  lastDeliveredAt: json['last_delivered_at'] == null ? null : DateTime.parse(json['last_delivered_at'] as String),
  lastDeliveredMessageId: json['last_delivered_message_id'] as String?,
);
