// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_context_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelContextResponse _$ChannelContextResponseFromJson(
  Map<String, dynamic> json,
) => ChannelContextResponse(
  cid: json['cid'] as String,
  createdBy: json['created_by'] == null ? null : UserResponse.fromJson(json['created_by'] as Map<String, dynamic>),
  id: json['id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$ChannelContextResponseToJson(
  ChannelContextResponse instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_by': instance.createdBy?.toJson(),
  'id': instance.id,
  'type': instance.type,
};
