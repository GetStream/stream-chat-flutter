// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageReminder _$MessageReminderFromJson(Map<String, dynamic> json) =>
    MessageReminder(
      channelCid: json['channel_cid'] as String,
      channel: json['channel'] == null
          ? null
          : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
      messageId: json['message_id'] as String,
      message: json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>),
      userId: json['user_id'] as String,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      remindAt: json['remind_at'] == null
          ? null
          : DateTime.parse(json['remind_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MessageReminderToJson(MessageReminder instance) =>
    <String, dynamic>{
      'channel_cid': instance.channelCid,
      'message_id': instance.messageId,
      'user_id': instance.userId,
      'remind_at': instance.remindAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
