// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_mark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageMark _$MessageMarkFromJson(Map<String, dynamic> json) => MessageMark(
  type: json['type'] as MessageMarkType,
  messageId: json['message_id'] as String,
  userId: json['user_id'] as String,
  user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageMarkToJson(MessageMark instance) => <String, dynamic>{
  'type': instance.type,
  'message_id': instance.messageId,
  'user_id': instance.userId,
  'user': instance.user?.toJson(),
  'created_at': instance.createdAt.toIso8601String(),
};
