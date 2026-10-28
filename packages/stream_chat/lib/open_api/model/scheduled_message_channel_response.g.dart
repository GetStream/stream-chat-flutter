// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_message_channel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledMessageChannelResponse _$ScheduledMessageChannelResponseFromJson(
  Map<String, dynamic> json,
) => ScheduledMessageChannelResponse(
  cid: json['cid'] as String,
  id: json['id'] as String,
  image: json['image'] as String?,
  name: json['name'] as String?,
  type: json['type'] as String,
);

Map<String, dynamic> _$ScheduledMessageChannelResponseToJson(
  ScheduledMessageChannelResponse instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'id': instance.id,
  'image': instance.image,
  'name': instance.name,
  'type': instance.type,
};
