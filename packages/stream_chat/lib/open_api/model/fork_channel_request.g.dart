// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fork_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForkChannelRequest _$ForkChannelRequestFromJson(Map<String, dynamic> json) => ForkChannelRequest(
  channel: ForkChannelTarget.fromJson(
    json['channel'] as Map<String, dynamic>,
  ),
  excludeAttachments: json['exclude_attachments'] as bool?,
  messageId: json['message_id'] as String,
);

Map<String, dynamic> _$ForkChannelRequestToJson(ForkChannelRequest instance) => <String, dynamic>{
  'channel': instance.channel.toJson(),
  'exclude_attachments': instance.excludeAttachments,
  'message_id': instance.messageId,
};
