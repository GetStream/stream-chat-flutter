// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_partial_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelPartialUpdateResponse _$ChannelPartialUpdateResponseFromJson(
  Map<String, dynamic> json,
) => ChannelPartialUpdateResponse(
  cid: json['cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  disabled: json['disabled'] as bool,
  frozen: json['frozen'] as bool,
  id: json['id'] as String,
  lastMessageAt: _$JsonConverterFromJson<Object, DateTime>(
    json['last_message_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$ChannelPartialUpdateResponseToJson(
  ChannelPartialUpdateResponse instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'disabled': instance.disabled,
  'frozen': instance.frozen,
  'id': instance.id,
  'last_message_at': _$JsonConverterToJson<Object, DateTime>(
    instance.lastMessageAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
