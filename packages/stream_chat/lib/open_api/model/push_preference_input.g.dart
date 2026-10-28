// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_preference_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushPreferenceInput _$PushPreferenceInputFromJson(Map<String, dynamic> json) => PushPreferenceInput(
  channelCid: json['channel_cid'] as String?,
  chatLevel: json['chat_level'] == null ? null : PushPreferenceInputChatLevel.fromJson(json['chat_level'] as String),
  chatPreferences: json['chat_preferences'] == null
      ? null
      : ChatPreferencesInput.fromJson(
          json['chat_preferences'] as Map<String, dynamic>,
        ),
  disabledUntil: _$JsonConverterFromJson<Object, DateTime>(
    json['disabled_until'],
    const StreamDateTimeConverter().fromJson,
  ),
  removeDisable: json['remove_disable'] as bool?,
  removeSchedule: json['remove_schedule'] as bool?,
  schedule: json['schedule'] == null
      ? null
      : PushScheduleInput.fromJson(
          json['schedule'] as Map<String, dynamic>,
        ),
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$PushPreferenceInputToJson(
  PushPreferenceInput instance,
) => <String, dynamic>{
  'channel_cid': instance.channelCid,
  'chat_level': instance.chatLevel?.toJson(),
  'chat_preferences': instance.chatPreferences?.toJson(),
  'disabled_until': _$JsonConverterToJson<Object, DateTime>(
    instance.disabledUntil,
    const StreamDateTimeConverter().toJson,
  ),
  'remove_disable': instance.removeDisable,
  'remove_schedule': instance.removeSchedule,
  'schedule': instance.schedule?.toJson(),
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
