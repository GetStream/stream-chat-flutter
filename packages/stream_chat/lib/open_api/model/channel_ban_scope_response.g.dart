// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_ban_scope_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelBanScopeResponse _$ChannelBanScopeResponseFromJson(
  Map<String, dynamic> json,
) => ChannelBanScopeResponse(
  bannedBy: json['banned_by'] == null ? null : UserResponse.fromJson(json['banned_by'] as Map<String, dynamic>),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  expires: _$JsonConverterFromJson<Object, DateTime>(
    json['expires'],
    const StreamDateTimeConverter().fromJson,
  ),
  reason: json['reason'] as String?,
  shadow: json['shadow'] as bool,
);

Map<String, dynamic> _$ChannelBanScopeResponseToJson(
  ChannelBanScopeResponse instance,
) => <String, dynamic>{
  'banned_by': instance.bannedBy?.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'expires': _$JsonConverterToJson<Object, DateTime>(
    instance.expires,
    const StreamDateTimeConverter().toJson,
  ),
  'reason': instance.reason,
  'shadow': instance.shadow,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
