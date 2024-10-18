// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String?,
      text: json['text'] as String?,
      type: json['type'] as String? ?? 'regular',
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
      reactionCounts: (json['reaction_counts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      reactionScores: (json['reaction_scores'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
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
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      i18n: (json['i18n'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'text': instance.text,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', Message._typeToJson(instance.type));
  val['attachments'] = instance.attachments.map((e) => e.toJson()).toList();
  val['mentioned_users'] = User.toIds(instance.mentionedUsers);
  val['parent_id'] = instance.parentId;
  val['quoted_message_id'] = instance.quotedMessageId;
  val['show_in_channel'] = instance.showInChannel;
  val['silent'] = instance.silent;
  val['pinned'] = instance.pinned;
  val['pin_expires'] = instance.pinExpires?.toIso8601String();
  val['extra_data'] = instance.extraData;
  return val;
}
