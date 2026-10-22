// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Draft _$DraftFromJson(Map<String, dynamic> json) => Draft(
  channelCid: json['channel_cid'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  message: DraftMessage.fromJson(json['message'] as Map<String, dynamic>),
  channel: _$JsonConverterFromJson<Map<String, dynamic>, ChannelModel>(
    json['channel'],
    const ChannelModelV1JsonConverter().fromJson,
  ),
  parentId: json['parent_id'] as String?,
  parentMessage: json['parent_message'] == null
      ? null
      : Message.fromJson(json['parent_message'] as Map<String, dynamic>),
  quotedMessage: json['quoted_message'] == null
      ? null
      : Message.fromJson(json['quoted_message'] as Map<String, dynamic>),
);

Value? _$JsonConverterFromJson<Json, Value>(Object? json, Value? Function(Json json) fromJson) =>
    json == null ? null : fromJson(json as Json);
