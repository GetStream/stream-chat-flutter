// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledMessage _$ScheduledMessageFromJson(Map<String, dynamic> json) => ScheduledMessage(
  id: json['id'] as String?,
  cid: json['cid'] as String,
  channel: json['channel'] == null ? null : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  message: Message.fromJson(json['message'] as Map<String, dynamic>),
  scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  status: json['status'] as ScheduledMessageStatus,
  failureReason: json['failure_reason'] as ScheduledMessageFailureReason?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);
