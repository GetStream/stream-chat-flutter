// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_push_preferences_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelPushPreferencesResponse _$ChannelPushPreferencesResponseFromJson(
  Map<String, dynamic> json,
) => ChannelPushPreferencesResponse(
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
);

Map<String, dynamic> _$ChannelPushPreferencesResponseToJson(
  ChannelPushPreferencesResponse instance,
) => <String, dynamic>{
  'chat_level': instance.chatLevel,
  'chat_preferences': instance.chatPreferences?.toJson(),
  'disabled_until': _$JsonConverterToJson<Object, DateTime>(
    instance.disabledUntil,
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
