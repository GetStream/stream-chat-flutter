// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadParticipant _$ThreadParticipantFromJson(Map<String, dynamic> json) => ThreadParticipant(
  channelCid: json['channel_cid'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  lastReadAt: DateTime.parse(json['last_read_at'] as String),
  lastThreadMessageAt: json['last_thread_message_at'] == null
      ? null
      : DateTime.parse(json['last_thread_message_at'] as String),
  leftThreadAt: json['left_thread_at'] == null ? null : DateTime.parse(json['left_thread_at'] as String),
  threadId: json['thread_id'] as String?,
  userId: json['user_id'] as String?,
  user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ThreadParticipantToJson(ThreadParticipant instance) => <String, dynamic>{
  'channel_cid': instance.channelCid,
  'created_at': instance.createdAt.toIso8601String(),
  'last_read_at': instance.lastReadAt.toIso8601String(),
  'last_thread_message_at': instance.lastThreadMessageAt?.toIso8601String(),
  'left_thread_at': instance.leftThreadAt?.toIso8601String(),
  'thread_id': instance.threadId,
  'user_id': instance.userId,
  'user': instance.user?.toJson(),
};
