// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_mutes_updated_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationMutesUpdatedEvent _$NotificationMutesUpdatedEventFromJson(
  Map<String, dynamic> json,
) => NotificationMutesUpdatedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  me: OwnUserResponse.fromJson(json['me'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$NotificationMutesUpdatedEventToJson(
  NotificationMutesUpdatedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'me': instance.me.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
