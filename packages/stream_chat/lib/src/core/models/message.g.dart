// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: json['id'] as String?,
  text: json['text'] as String?,
  type: json['type'] == null ? MessageType.regular : MessageType.fromJson(json['type'] as String),
  attachments:
      (json['attachments'] as List<dynamic>?)?.map((e) => Attachment.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  mentionedChannel: json['mentioned_channel'] as bool?,
  mentionedGroupIds: (json['mentioned_group_ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
  mentionedGroups: userGroupsFromV1Json(json['mentioned_groups'] as List?),
  mentionedHere: json['mentioned_here'] as bool?,
  mentionedRoles: (json['mentioned_roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
  mentionedUsers:
      (json['mentioned_users'] as List<dynamic>?)?.map((e) => User.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  silent: json['silent'] as bool? ?? false,
  shadowed: json['shadowed'] as bool? ?? false,
  reactionGroups: reactionGroupsFromV1Json(
    Message._reactionGroupsReadValue(json, 'reaction_groups') as Map<String, dynamic>?,
  ),
  latestReactions: (json['latest_reactions'] as List<dynamic>?)
      ?.map((e) => const ReactionV1JsonConverter().fromJson(e as Map<String, dynamic>))
      .toList(),
  ownReactions: (json['own_reactions'] as List<dynamic>?)
      ?.map((e) => const ReactionV1JsonConverter().fromJson(e as Map<String, dynamic>))
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
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at'] as String),
  deletedForMe: json['deleted_for_me'] as bool?,
  messageTextUpdatedAt: json['message_text_updated_at'] == null
      ? null
      : DateTime.parse(json['message_text_updated_at'] as String),
  user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
  pinned: json['pinned'] as bool? ?? false,
  pinnedAt: json['pinned_at'] == null ? null : DateTime.parse(json['pinned_at'] as String),
  pinExpires: json['pin_expires'] == null ? null : DateTime.parse(json['pin_expires'] as String),
  pinnedBy: json['pinned_by'] == null ? null : User.fromJson(json['pinned_by'] as Map<String, dynamic>),
  poll: _$JsonConverterFromJson<Map<String, dynamic>, Poll>(json['poll'], const PollV1JsonConverter().fromJson),
  pollId: json['poll_id'] as String?,
  extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
  i18n: (json['i18n'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)),
  restrictedVisibility: (json['restricted_visibility'] as List<dynamic>?)?.map((e) => e as String).toList(),
  moderation: moderationFromV1Json(Message._moderationReadValue(json, 'moderation') as Map<String, dynamic>?),
  draft: json['draft'] == null ? null : Draft.fromJson(json['draft'] as Map<String, dynamic>),
  reminder: json['reminder'] == null ? null : MessageReminder.fromJson(json['reminder'] as Map<String, dynamic>),
  channelRole: Message._channelRoleReadValue(json, 'channel_role') as String?,
  sharedLocation: _$JsonConverterFromJson<Map<String, dynamic>, Location>(
    json['shared_location'],
    const LocationV1JsonConverter().fromJson,
  ),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'type': ?MessageType.toJson(instance.type),
  'attachments': instance.attachments.map((e) => e.toJson()).toList(),
  'mentioned_channel': ?instance.mentionedChannel,
  'mentioned_group_ids': ?instance.mentionedGroupIds,
  'mentioned_here': ?instance.mentionedHere,
  'mentioned_roles': ?instance.mentionedRoles,
  'mentioned_users': User.toIds(instance.mentionedUsers),
  'parent_id': instance.parentId,
  'quoted_message_id': instance.quotedMessageId,
  'show_in_channel': instance.showInChannel,
  'silent': instance.silent,
  'pinned': instance.pinned,
  'pin_expires': instance.pinExpires?.toIso8601String(),
  'poll_id': instance.pollId,
  'restricted_visibility': ?instance.restrictedVisibility,
  'shared_location': ?_$JsonConverterToJson<Map<String, dynamic>, Location>(
    instance.sharedLocation,
    const LocationV1JsonConverter().toJson,
  ),
  'extra_data': instance.extraData,
};

Value? _$JsonConverterFromJson<Json, Value>(Object? json, Value? Function(Json json) fromJson) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(Value? value, Json? Function(Value value) toJson) =>
    value == null ? null : toJson(value);
