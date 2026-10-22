// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
  type: json['type'] as String? ?? 'local.event',
  userId: json['user_id'] as String?,
  cid: json['cid'] as String?,
  connectionId: json['connection_id'] as String?,
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
  me: json['me'] == null ? null : OwnUser.fromJson(json['me'] as Map<String, dynamic>),
  user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
  message: json['message'] == null ? null : Message.fromJson(json['message'] as Map<String, dynamic>),
  poll: pollFromV1Json(json['poll'] as Map<String, dynamic>?),
  pollVote: pollVoteFromV1Json(json['poll_vote'] as Map<String, dynamic>?),
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  reaction: reactionFromV1Json(json['reaction'] as Map<String, dynamic>?),
  online: json['online'] as bool?,
  channel: _$JsonConverterFromJson<Map<String, dynamic>, ChannelModel>(
    json['channel'],
    const ChannelModelV1JsonConverter().fromJson,
  ),
  member: memberFromV1Json(json['member'] as Map<String, dynamic>?),
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  channelLastMessageAt: json['channel_last_message_at'] == null
      ? null
      : DateTime.parse(json['channel_last_message_at'] as String),
  parentId: json['parent_id'] as String?,
  hardDelete: json['hard_delete'] as bool?,
  deletedForMe: json['deleted_for_me'] as bool?,
  aiState: $enumDecodeNullable(
    _$AITypingStateEnumMap,
    Event._aiStateReadValue(json, 'ai_state'),
    unknownValue: AITypingState.idle,
  ),
  aiMessage: json['ai_message'] as String?,
  messageId: json['message_id'] as String?,
  thread: threadFromV1Json(json['thread'] as Map<String, dynamic>?),
  unreadThreadMessages: (json['unread_thread_messages'] as num?)?.toInt(),
  unreadThreads: (json['unread_threads'] as num?)?.toInt(),
  lastReadAt: json['last_read_at'] == null ? null : DateTime.parse(json['last_read_at'] as String),
  unreadMessages: (json['unread_messages'] as num?)?.toInt(),
  lastReadMessageId: json['last_read_message_id'] as String?,
  draft: json['draft'] == null ? null : Draft.fromJson(json['draft'] as Map<String, dynamic>),
  reminder: messageReminderFromV1Json(json['reminder'] as Map<String, dynamic>?),
  pushPreference: json['push_preference'] == null
      ? null
      : PushPreference.fromJson(json['push_preference'] as Map<String, dynamic>),
  channelPushPreference: json['channel_push_preference'] == null
      ? null
      : ChannelPushPreference.fromJson(json['channel_push_preference'] as Map<String, dynamic>),
  channelMemberCount: (json['channel_member_count'] as num?)?.toInt(),
  channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
  watcherCount: (json['watcher_count'] as num?)?.toInt(),
  lastDeliveredAt: json['last_delivered_at'] == null ? null : DateTime.parse(json['last_delivered_at'] as String),
  lastDeliveredMessageId: json['last_delivered_message_id'] as String?,
  extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
  isLocal: json['is_local'] as bool? ?? false,
);

Value? _$JsonConverterFromJson<Json, Value>(Object? json, Value? Function(Json json) fromJson) =>
    json == null ? null : fromJson(json as Json);

const _$AITypingStateEnumMap = {
  AITypingState.idle: 'AI_STATE_IDLE',
  AITypingState.error: 'AI_STATE_ERROR',
  AITypingState.checkingSources: 'AI_STATE_CHECKING_SOURCES',
  AITypingState.thinking: 'AI_STATE_THINKING',
  AITypingState.generating: 'AI_STATE_GENERATING',
};
