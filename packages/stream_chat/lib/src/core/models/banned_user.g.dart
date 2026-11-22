// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banned_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannedUser _$BannedUserFromJson(Map<String, dynamic> json) => BannedUser(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  bannedBy: json['banned_by'] == null ? null : User.fromJson(json['banned_by'] as Map<String, dynamic>),
  channel: _$JsonConverterFromJson<Map<String, dynamic>, ChannelModel>(
    json['channel'],
    const ChannelModelV1JsonConverter().fromJson,
  ),
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
  expires: json['expires'] == null ? null : DateTime.parse(json['expires'] as String),
  shadow: json['shadow'] as bool? ?? false,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$BannedUserToJson(BannedUser instance) => <String, dynamic>{
  'user': instance.user.toJson(),
  'banned_by': instance.bannedBy?.toJson(),
  'channel': _$JsonConverterToJson<Map<String, dynamic>, ChannelModel>(
    instance.channel,
    const ChannelModelV1JsonConverter().toJson,
  ),
  'created_at': instance.createdAt?.toIso8601String(),
  'expires': instance.expires?.toIso8601String(),
  'shadow': instance.shadow,
  'reason': instance.reason,
};

Value? _$JsonConverterFromJson<Json, Value>(Object? json, Value? Function(Json json) fromJson) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(Value? value, Json? Function(Value value) toJson) =>
    value == null ? null : toJson(value);
