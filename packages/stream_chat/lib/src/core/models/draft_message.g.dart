// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftMessage _$DraftMessageFromJson(Map<String, dynamic> json) => DraftMessage(
      id: json['id'] as String?,
      text: json['text'] as String?,
      type: json['type'] == null
          ? MessageType.regular
          : MessageType.fromJson(json['type'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      parentId: json['parent_id'] as String?,
      showInChannel: json['show_in_channel'] as bool?,
      mentionedUsers: (json['mentioned_users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      quotedMessage: json['quoted_message'] == null
          ? null
          : Message.fromJson(json['quoted_message'] as Map<String, dynamic>),
      quotedMessageId: json['quoted_message_id'] as String?,
      silent: json['silent'] as bool? ?? false,
      poll: json['poll'] == null
          ? null
          : Poll.fromJson(json['poll'] as Map<String, dynamic>),
      pollId: json['poll_id'] as String?,
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$DraftMessageToJson(DraftMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.text case final value?) 'text': value,
      if (MessageType.toJson(instance.type) case final value?) 'type': value,
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
      if (instance.parentId case final value?) 'parent_id': value,
      if (instance.showInChannel case final value?) 'show_in_channel': value,
      if (User.toIds(instance.mentionedUsers) case final value?)
        'mentioned_users': value,
      if (instance.quotedMessageId case final value?)
        'quoted_message_id': value,
      'silent': instance.silent,
      if (instance.pollId case final value?) 'poll_id': value,
      'extra_data': instance.extraData,
    };
