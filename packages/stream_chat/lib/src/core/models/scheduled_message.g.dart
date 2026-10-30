// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledMessage _$ScheduledMessageFromJson(Map<String, dynamic> json) => ScheduledMessage(
  id: json['id'] as String,
  cid: json['cid'] as String,
  channel: json['channel'] == null ? null : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  message: _messagePlaceholder(json['message']),
  scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  status: json['status'] as ScheduledMessageStatus,
  failureReason: json['failure_reason'] as ScheduledMessageFailureReason?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ScheduledMessageToJson(ScheduledMessage instance) => <String, dynamic>{
  'id': instance.id,
  'cid': instance.cid,
  'channel': instance.channel?.toJson(),
  'user': instance.user.toJson(),
  'message': _messageToContent(instance.message),
  'scheduled_at': instance.scheduledAt.toIso8601String(),
  'status': instance.status,
  'failure_reason': instance.failureReason,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
