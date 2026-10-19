// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_message_updated_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledMessageUpdatedEvent _$ScheduledMessageUpdatedEventFromJson(
  Map<String, dynamic> json,
) => ScheduledMessageUpdatedEvent(
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  scheduledMessage: json['scheduled_message'] == null
      ? null
      : ScheduledMessageResponse.fromJson(
          json['scheduled_message'] as Map<String, dynamic>,
        ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduledMessageUpdatedEventToJson(
  ScheduledMessageUpdatedEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'scheduled_message': instance.scheduledMessage?.toJson(),
  'type': instance.type,
  'user': instance.user.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
