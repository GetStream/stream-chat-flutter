// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_change_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageChangeSet _$MessageChangeSetFromJson(Map<String, dynamic> json) =>
    MessageChangeSet(
      attachments: json['attachments'] as bool,
      custom: json['custom'] as bool,
      html: json['html'] as bool,
      mentionedUserIds: json['mentioned_user_ids'] as bool,
      mml: json['mml'] as bool,
      pin: json['pin'] as bool,
      quotedMessageId: json['quoted_message_id'] as bool,
      silent: json['silent'] as bool,
      text: json['text'] as bool,
    );

Map<String, dynamic> _$MessageChangeSetToJson(MessageChangeSet instance) =>
    <String, dynamic>{
      'attachments': instance.attachments,
      'custom': instance.custom,
      'html': instance.html,
      'mentioned_user_ids': instance.mentionedUserIds,
      'mml': instance.mml,
      'pin': instance.pin,
      'quoted_message_id': instance.quotedMessageId,
      'silent': instance.silent,
      'text': instance.text,
    };
