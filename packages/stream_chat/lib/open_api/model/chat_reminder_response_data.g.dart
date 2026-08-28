// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_reminder_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatReminderResponseData _$ChatReminderResponseDataFromJson(
  Map<String, dynamic> json,
) => ChatReminderResponseData(
  channelCid: json['channel_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  message: json['message'] == null
      ? null
      : ChatMessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  remindAt: _$JsonConverterFromJson<Object, DateTime>(
    json['remind_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: json['user'] == null
      ? null
      : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ChatReminderResponseDataToJson(
  ChatReminderResponseData instance,
) => <String, dynamic>{
  'channel_cid': instance.channelCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'message': instance.message?.toJson(),
  'message_id': instance.messageId,
  'remind_at': _$JsonConverterToJson<Object, DateTime>(
    instance.remindAt,
    const StreamDateTimeConverter().toJson,
  ),
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user?.toJson(),
  'user_id': instance.userId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
