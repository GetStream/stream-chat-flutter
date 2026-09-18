// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftResponse _$DraftResponseFromJson(Map<String, dynamic> json) => DraftResponse(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  channelCid: json['channel_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  message: DraftPayloadResponse.fromJson(
    json['message'] as Map<String, dynamic>,
  ),
  parentId: json['parent_id'] as String?,
  parentMessage: json['parent_message'] == null
      ? null
      : MessageResponse.fromJson(
          json['parent_message'] as Map<String, dynamic>,
        ),
  quotedMessage: json['quoted_message'] == null
      ? null
      : MessageResponse.fromJson(
          json['quoted_message'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$DraftResponseToJson(DraftResponse instance) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'channel_cid': instance.channelCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'message': instance.message.toJson(),
  'parent_id': instance.parentId,
  'parent_message': instance.parentMessage?.toJson(),
  'quoted_message': instance.quotedMessage?.toJson(),
};
