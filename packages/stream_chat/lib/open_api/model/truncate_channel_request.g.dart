// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truncate_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TruncateChannelRequest _$TruncateChannelRequestFromJson(
  Map<String, dynamic> json,
) => TruncateChannelRequest(
  hardDelete: json['hard_delete'] as bool?,
  memberIds: (json['member_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  message: json['message'] == null
      ? null
      : MessageRequest.fromJson(json['message'] as Map<String, dynamic>),
  skipPush: json['skip_push'] as bool?,
  truncatedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['truncated_at'],
    const StreamDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$TruncateChannelRequestToJson(
  TruncateChannelRequest instance,
) => <String, dynamic>{
  'hard_delete': instance.hardDelete,
  'member_ids': instance.memberIds,
  'message': instance.message?.toJson(),
  'skip_push': instance.skipPush,
  'truncated_at': _$JsonConverterToJson<Object, DateTime>(
    instance.truncatedAt,
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
