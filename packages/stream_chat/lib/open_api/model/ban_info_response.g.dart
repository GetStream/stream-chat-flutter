// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ban_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanInfoResponse _$BanInfoResponseFromJson(Map<String, dynamic> json) => BanInfoResponse(
  channel: json['channel'] == null ? null : ChannelMetadata.fromJson(json['channel'] as Map<String, dynamic>),
  channelCid: json['channel_cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null ? null : UserResponse.fromJson(json['created_by'] as Map<String, dynamic>),
  expires: _$JsonConverterFromJson<Object, DateTime>(
    json['expires'],
    const StreamDateTimeConverter().fromJson,
  ),
  reason: json['reason'] as String?,
  shadow: json['shadow'] as bool?,
  user: json['user'] == null ? null : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BanInfoResponseToJson(BanInfoResponse instance) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'channel_cid': instance.channelCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy?.toJson(),
  'expires': _$JsonConverterToJson<Object, DateTime>(
    instance.expires,
    const StreamDateTimeConverter().toJson,
  ),
  'reason': instance.reason,
  'shadow': instance.shadow,
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
