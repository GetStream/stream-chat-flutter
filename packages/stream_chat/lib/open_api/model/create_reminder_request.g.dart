// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reminder_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReminderRequest _$CreateReminderRequestFromJson(
  Map<String, dynamic> json,
) => CreateReminderRequest(
  remindAt: _$JsonConverterFromJson<Object, DateTime>(
    json['remind_at'],
    const StreamDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$CreateReminderRequestToJson(
  CreateReminderRequest instance,
) => <String, dynamic>{
  'remind_at': _$JsonConverterToJson<Object, DateTime>(
    instance.remindAt,
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
