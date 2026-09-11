// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_live_location_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateLiveLocationRequest _$UpdateLiveLocationRequestFromJson(
  Map<String, dynamic> json,
) => UpdateLiveLocationRequest(
  endAt: _$JsonConverterFromJson<Object, DateTime>(
    json['end_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  messageId: json['message_id'] as String,
);

Map<String, dynamic> _$UpdateLiveLocationRequestToJson(
  UpdateLiveLocationRequest instance,
) => <String, dynamic>{
  'end_at': _$JsonConverterToJson<Object, DateTime>(
    instance.endAt,
    const StreamDateTimeConverter().toJson,
  ),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'message_id': instance.messageId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
