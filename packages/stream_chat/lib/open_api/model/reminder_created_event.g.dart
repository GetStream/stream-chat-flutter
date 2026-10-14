// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_created_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderCreatedEvent _$ReminderCreatedEventFromJson(
  Map<String, dynamic> json,
) => ReminderCreatedEvent(
  cid: json['cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String,
  parentId: json['parent_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reminder: ReminderResponseData.fromJson(
    json['reminder'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ReminderCreatedEventToJson(
  ReminderCreatedEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'parent_id': instance.parentId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'reminder': instance.reminder.toJson(),
  'type': instance.type,
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
