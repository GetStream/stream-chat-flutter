// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String?,
      text: json['text'] as String?,
      type: json['type'] == null
          ? MessageType.regular
          : MessageType.fromJson(json['type'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      mentionedUsers: (json['mentioned_users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      silent: json['silent'] as bool? ?? false,
      shadowed: json['shadowed'] as bool? ?? false,
      reactionGroups: (Message._reactionGroupsReadValue(json, 'reaction_groups')
              as Map<String, dynamic>?)
          ?.map(
        (k, e) =>
            MapEntry(k, ReactionGroup.fromJson(e as Map<String, dynamic>)),
      ),
      latestReactions: (json['latest_reactions'] as List<dynamic>?)
          ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      ownReactions: (json['own_reactions'] as List<dynamic>?)
          ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      parentId: json['parent_id'] as String?,
      quotedMessage: json['quoted_message'] == null
          ? null
          : Message.fromJson(json['quoted_message'] as Map<String, dynamic>),
      quotedMessageId: json['quoted_message_id'] as String?,
      replyCount: (json['reply_count'] as num?)?.toInt() ?? 0,
      threadParticipants: (json['thread_participants'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      showInChannel: json['show_in_channel'] as bool?,
      command: json['command'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      deletedOnlyForMe: json['deleted_for_me'] as bool? ?? false,
      messageTextUpdatedAt: json['message_text_updated_at'] == null
          ? null
          : DateTime.parse(json['message_text_updated_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      pinned: json['pinned'] as bool? ?? false,
      pinnedAt: json['pinned_at'] == null
          ? null
          : DateTime.parse(json['pinned_at'] as String),
      pinExpires: json['pin_expires'] == null
          ? null
          : DateTime.parse(json['pin_expires'] as String),
      pinnedBy: json['pinned_by'] == null
          ? null
          : User.fromJson(json['pinned_by'] as Map<String, dynamic>),
      poll: json['poll'] == null
          ? null
          : Poll.fromJson(json['poll'] as Map<String, dynamic>),
      pollId: json['poll_id'] as String?,
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      i18n: (json['i18n'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      restrictedVisibility: (json['restricted_visibility'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      moderation: Message._moderationReadValue(json, 'moderation') == null
          ? null
          : Moderation.fromJson(Message._moderationReadValue(json, 'moderation')
              as Map<String, dynamic>),
      draft: json['draft'] == null
          ? null
          : Draft.fromJson(json['draft'] as Map<String, dynamic>),
      reminder: json['reminder'] == null
          ? null
          : MessageReminder.fromJson(json['reminder'] as Map<String, dynamic>),
      sharedLocation: json['shared_location'] == null
          ? null
          : Location.fromJson(json['shared_location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      if (MessageType.toJson(instance.type) case final value?) 'type': value,
      'attachments': instance.attachments.map((e) => e.toJson()).toList(),
      'mentioned_users': User.toIds(instance.mentionedUsers),
      'parent_id': instance.parentId,
      'quoted_message_id': instance.quotedMessageId,
      'show_in_channel': instance.showInChannel,
      'silent': instance.silent,
      'pinned': instance.pinned,
      'pin_expires': instance.pinExpires?.toIso8601String(),
      'poll_id': instance.pollId,
      if (instance.restrictedVisibility case final value?)
        'restricted_visibility': value,
      if (instance.sharedLocation?.toJson() case final value?)
        'shared_location': value,
      'extra_data': instance.extraData,
    };
