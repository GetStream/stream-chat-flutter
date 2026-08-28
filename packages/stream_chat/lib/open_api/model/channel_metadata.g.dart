// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMetadata _$ChannelMetadataFromJson(Map<String, dynamic> json) =>
    ChannelMetadata(
      cid: json['cid'] as String,
      custom: json['custom'] as Map<String, dynamic>,
      id: json['id'] as String,
      lastMessageAt: _$JsonConverterFromJson<Object, DateTime>(
        json['last_message_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      memberCount: (json['member_count'] as num?)?.toInt(),
      messageCount: (json['message_count'] as num?)?.toInt(),
      pushLevel: json['push_level'] as String?,
      team: json['team'] as String?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ChannelMetadataToJson(ChannelMetadata instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'custom': instance.custom,
      'id': instance.id,
      'last_message_at': _$JsonConverterToJson<Object, DateTime>(
        instance.lastMessageAt,
        const StreamDateTimeConverter().toJson,
      ),
      'member_count': instance.memberCount,
      'message_count': instance.messageCount,
      'push_level': instance.pushLevel,
      'team': instance.team,
      'type': instance.type,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
