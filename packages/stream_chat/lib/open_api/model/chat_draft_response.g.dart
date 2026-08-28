// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_draft_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDraftResponse _$ChatDraftResponseFromJson(Map<String, dynamic> json) =>
    ChatDraftResponse(
      channelCid: json['channel_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      message: ChatDraftPayloadResponse.fromJson(
        json['message'] as Map<String, dynamic>,
      ),
      parentId: json['parent_id'] as String?,
      parentMessage: json['parent_message'] == null
          ? null
          : ChatMessageResponse.fromJson(
              json['parent_message'] as Map<String, dynamic>,
            ),
      quotedMessage: json['quoted_message'] == null
          ? null
          : ChatMessageResponse.fromJson(
              json['quoted_message'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ChatDraftResponseToJson(ChatDraftResponse instance) =>
    <String, dynamic>{
      'channel_cid': instance.channelCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'message': instance.message.toJson(),
      'parent_id': instance.parentId,
      'parent_message': instance.parentMessage?.toJson(),
      'quoted_message': instance.quotedMessage?.toJson(),
    };
