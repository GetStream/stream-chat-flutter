// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_message_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledMessageLocation _$ScheduledMessageLocationFromJson(
  Map<String, dynamic> json,
) => ScheduledMessageLocation(
  createdByDeviceId: json['created_by_device_id'] as String,
  endAt: _$JsonConverterFromJson<Object, DateTime>(
    json['end_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ScheduledMessageLocationToJson(
  ScheduledMessageLocation instance,
) => <String, dynamic>{
  'created_by_device_id': instance.createdByDeviceId,
  'end_at': _$JsonConverterToJson<Object, DateTime>(
    instance.endAt,
    const StreamDateTimeConverter().toJson,
  ),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
