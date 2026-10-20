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
  poll: _$JsonConverterFromJson<Map<String, dynamic>, Poll>(json['poll'], const PollV1JsonConverter().fromJson),
  pollVote: _$JsonConverterFromJson<Map<String, dynamic>, PollVote>(
    json['poll_vote'],
    const PollVoteV1JsonConverter().fromJson,
  ),
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  reaction: _$JsonConverterFromJson<Map<String, dynamic>, Reaction>(
    json['reaction'],
    const ReactionV1JsonConverter().fromJson,
  ),
  online: json['online'] as bool?,
  channel: json['channel'] == null ? null : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
  member: json['member'] == null ? null : Member.fromJson(json['member'] as Map<String, dynamic>),
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
  thread: _$JsonConverterFromJson<Map<String, dynamic>, Thread>(json['thread'], const ThreadV1JsonConverter().fromJson),
  unreadThreadMessages: (json['unread_thread_messages'] as num?)?.toInt(),
  unreadThreads: (json['unread_threads'] as num?)?.toInt(),
  lastReadAt: json['last_read_at'] == null ? null : DateTime.parse(json['last_read_at'] as String),
  unreadMessages: (json['unread_messages'] as num?)?.toInt(),
  lastReadMessageId: json['last_read_message_id'] as String?,
  draft: json['draft'] == null ? null : Draft.fromJson(json['draft'] as Map<String, dynamic>),
  reminder: _$JsonConverterFromJson<Map<String, dynamic>, MessageReminder>(
    json['reminder'],
    const MessageReminderV1JsonConverter().fromJson,
  ),
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

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'type': instance.type,
  'user_id': ?instance.userId,
  'cid': ?instance.cid,
  'channel_id': ?instance.channelId,
  'channel_type': ?instance.channelType,
  'channel_last_message_at': ?instance.channelLastMessageAt?.toIso8601String(),
  'connection_id': ?instance.connectionId,
  'created_at': instance.createdAt.toIso8601String(),
  'me': ?instance.me?.toJson(),
  'user': ?instance.user?.toJson(),
  'message': ?instance.message?.toJson(),
  'poll': ?_$JsonConverterToJson<Map<String, dynamic>, Poll>(instance.poll, const PollV1JsonConverter().toJson),
  'poll_vote': ?_$JsonConverterToJson<Map<String, dynamic>, PollVote>(
    instance.pollVote,
    const PollVoteV1JsonConverter().toJson,
  ),
  'channel': ?instance.channel?.toJson(),
  'member': ?instance.member?.toJson(),
  'reaction': ?_$JsonConverterToJson<Map<String, dynamic>, Reaction>(
    instance.reaction,
    const ReactionV1JsonConverter().toJson,
  ),
  'total_unread_count': ?instance.totalUnreadCount,
  'unread_channels': ?instance.unreadChannels,
  'online': ?instance.online,
  'parent_id': ?instance.parentId,
  'is_local': instance.isLocal,
  'hard_delete': ?instance.hardDelete,
  'deleted_for_me': ?instance.deletedForMe,
  'ai_state': ?_$AITypingStateEnumMap[instance.aiState],
  'ai_message': ?instance.aiMessage,
  'message_id': ?instance.messageId,
  'thread': ?_$JsonConverterToJson<Map<String, dynamic>, Thread>(instance.thread, const ThreadV1JsonConverter().toJson),
  'unread_thread_messages': ?instance.unreadThreadMessages,
  'unread_threads': ?instance.unreadThreads,
  'last_read_at': ?instance.lastReadAt?.toIso8601String(),
  'unread_messages': ?instance.unreadMessages,
  'last_read_message_id': ?instance.lastReadMessageId,
  'draft': ?instance.draft?.toJson(),
  'reminder': ?_$JsonConverterToJson<Map<String, dynamic>, MessageReminder>(
    instance.reminder,
    const MessageReminderV1JsonConverter().toJson,
  ),
  'push_preference': ?instance.pushPreference?.toJson(),
  'channel_push_preference': ?instance.channelPushPreference?.toJson(),
  'channel_member_count': ?instance.channelMemberCount,
  'channel_message_count': ?instance.channelMessageCount,
  'watcher_count': ?instance.watcherCount,
  'last_delivered_at': ?instance.lastDeliveredAt?.toIso8601String(),
  'last_delivered_message_id': ?instance.lastDeliveredMessageId,
  'extra_data': instance.extraData,
};

Value? _$JsonConverterFromJson<Json, Value>(Object? json, Value? Function(Json json) fromJson) =>
    json == null ? null : fromJson(json as Json);

const _$AITypingStateEnumMap = {
  AITypingState.idle: 'AI_STATE_IDLE',
  AITypingState.error: 'AI_STATE_ERROR',
  AITypingState.checkingSources: 'AI_STATE_CHECKING_SOURCES',
  AITypingState.thinking: 'AI_STATE_THINKING',
  AITypingState.generating: 'AI_STATE_GENERATING',
};

Json? _$JsonConverterToJson<Json, Value>(Value? value, Json? Function(Value value) toJson) =>
    value == null ? null : toJson(value);
