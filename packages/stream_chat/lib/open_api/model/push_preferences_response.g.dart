// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_preferences_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushPreferencesResponse _$PushPreferencesResponseFromJson(
  Map<String, dynamic> json,
) => PushPreferencesResponse(
  chatLevel: json['chat_level'] as String?,
  chatPreferences: json['chat_preferences'] == null
      ? null
      : ChatPreferencesResponse.fromJson(
          json['chat_preferences'] as Map<String, dynamic>,
        ),
  disabledUntil: _$JsonConverterFromJson<Object, DateTime>(
    json['disabled_until'],
    const StreamDateTimeConverter().fromJson,
  ),
  schedule: json['schedule'] == null ? null : PushScheduleResponse.fromJson(json['schedule'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PushPreferencesResponseToJson(
  PushPreferencesResponse instance,
) => <String, dynamic>{
  'chat_level': instance.chatLevel,
  'chat_preferences': instance.chatPreferences?.toJson(),
  'disabled_until': _$JsonConverterToJson<Object, DateTime>(
    instance.disabledUntil,
    const StreamDateTimeConverter().toJson,
  ),
  'schedule': instance.schedule?.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
