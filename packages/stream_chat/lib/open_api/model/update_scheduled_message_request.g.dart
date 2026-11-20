// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_scheduled_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateScheduledMessageRequest _$UpdateScheduledMessageRequestFromJson(
  Map<String, dynamic> json,
) => UpdateScheduledMessageRequest(
  message: json['message'] == null ? null : MessageRequest.fromJson(json['message'] as Map<String, dynamic>),
  scheduledAt: _$JsonConverterFromJson<Object, DateTime>(
    json['scheduled_at'],
    const StreamDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$UpdateScheduledMessageRequestToJson(
  UpdateScheduledMessageRequest instance,
) => <String, dynamic>{
  'message': instance.message?.toJson(),
  'scheduled_at': _$JsonConverterToJson<Object, DateTime>(
    instance.scheduledAt,
    const StreamDateTimeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
