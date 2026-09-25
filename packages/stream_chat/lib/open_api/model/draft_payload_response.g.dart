// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_payload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftPayloadResponse _$DraftPayloadResponseFromJson(
  Map<String, dynamic> json,
) => DraftPayloadResponse(
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
      .toList(),
  custom: json['custom'] as Map<String, dynamic>,
  html: json['html'] as String?,
  id: json['id'] as String,
  mentionedUsers: (json['mentioned_users'] as List<dynamic>?)
      ?.map((e) => UserResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  mml: json['mml'] as String?,
  parentId: json['parent_id'] as String?,
  pollId: json['poll_id'] as String?,
  quotedMessageId: json['quoted_message_id'] as String?,
  showInChannel: json['show_in_channel'] as bool?,
  silent: json['silent'] as bool?,
  text: json['text'] as String,
  type: json['type'] as String?,
);

Map<String, dynamic> _$DraftPayloadResponseToJson(
  DraftPayloadResponse instance,
) => <String, dynamic>{
  'attachments': instance.attachments?.map((e) => e.toJson()).toList(),
  'custom': instance.custom,
  'html': instance.html,
  'id': instance.id,
  'mentioned_users': instance.mentionedUsers?.map((e) => e.toJson()).toList(),
  'mml': instance.mml,
  'parent_id': instance.parentId,
  'poll_id': instance.pollId,
  'quoted_message_id': instance.quotedMessageId,
  'show_in_channel': instance.showInChannel,
  'silent': instance.silent,
  'text': instance.text,
  'type': instance.type,
};
