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
    );

Map<String, dynamic> _$ReadToJson(Read instance) => <String, dynamic>{
      'last_read': instance.lastRead.toIso8601String(),
      'user': instance.user.toJson(),
      'unread_messages': instance.unreadMessages,
      'last_read_message_id': instance.lastReadMessageId,
    };
