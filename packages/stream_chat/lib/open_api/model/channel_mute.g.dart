// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMute _$ChannelMuteFromJson(Map<String, dynamic> json) => ChannelMute(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  expires: _$JsonConverterFromJson<Object, DateTime>(
    json['expires'],
    const StreamDateTimeConverter().fromJson,
  ),
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: json['user'] == null ? null : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelMuteToJson(ChannelMute instance) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'expires': _$JsonConverterToJson<Object, DateTime>(
    instance.expires,
    const StreamDateTimeConverter().toJson,
  ),
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user?.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
