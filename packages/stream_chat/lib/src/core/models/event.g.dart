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
  poll: json['poll'] == null ? null : Poll.fromJson(json['poll'] as Map<String, dynamic>),
  pollVote: json['poll_vote'] == null ? null : PollVote.fromJson(json['poll_vote'] as Map<String, dynamic>),
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  reaction: json['reaction'] == null ? null : Reaction.fromJson(json['reaction'] as Map<String, dynamic>),
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
  aiState: $enumDecodeNullable(_$AITypingStateEnumMap, json['ai_state'], unknownValue: AITypingState.idle),
  aiMessage: json['ai_message'] as String?,
  messageId: json['message_id'] as String?,
  thread: json['thread'] == null ? null : Thread.fromJson(json['thread'] as Map<String, dynamic>),
  unreadThreadMessages: (json['unread_thread_messages'] as num?)?.toInt(),
  unreadThreads: (json['unread_threads'] as num?)?.toInt(),
  lastReadAt: json['last_read_at'] == null ? null : DateTime.parse(json['last_read_at'] as String),
  unreadMessages: (json['unread_messages'] as num?)?.toInt(),
  lastReadMessageId: json['last_read_message_id'] as String?,
  draft: json['draft'] == null ? null : Draft.fromJson(json['draft'] as Map<String, dynamic>),
  reminder: json['reminder'] == null ? null : MessageReminder.fromJson(json['reminder'] as Map<String, dynamic>),
  pushPreference: json['push_preference'] == null
      ? null
      : PushPreference.fromJson(json['push_preference'] as Map<String, dynamic>),
  channelPushPreference: json['channel_push_preference'] == null
      ? null
      : ChannelPushPreference.fromJson(json['channel_push_preference'] as Map<String, dynamic>),
  channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
  lastDeliveredAt: json['last_delivered_at'] == null ? null : DateTime.parse(json['last_delivered_at'] as String),
  lastDeliveredMessageId: json['last_delivered_message_id'] as String?,
  extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
  isLocal: json['is_local'] as bool? ?? false,
);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'type': instance.type,
  if (instance.userId case final value?) 'user_id': value,
  if (instance.cid case final value?) 'cid': value,
  if (instance.channelId case final value?) 'channel_id': value,
  if (instance.channelType case final value?) 'channel_type': value,
  if (instance.channelLastMessageAt?.toIso8601String() case final value?) 'channel_last_message_at': value,
  if (instance.connectionId case final value?) 'connection_id': value,
  'created_at': instance.createdAt.toIso8601String(),
  if (instance.me?.toJson() case final value?) 'me': value,
  if (instance.user?.toJson() case final value?) 'user': value,
  if (instance.message?.toJson() case final value?) 'message': value,
  if (instance.poll?.toJson() case final value?) 'poll': value,
  if (instance.pollVote?.toJson() case final value?) 'poll_vote': value,
  if (instance.channel?.toJson() case final value?) 'channel': value,
  if (instance.member?.toJson() case final value?) 'member': value,
  if (instance.reaction?.toJson() case final value?) 'reaction': value,
  if (instance.totalUnreadCount case final value?) 'total_unread_count': value,
  if (instance.unreadChannels case final value?) 'unread_channels': value,
  if (instance.online case final value?) 'online': value,
  if (instance.parentId case final value?) 'parent_id': value,
  'is_local': instance.isLocal,
  if (instance.hardDelete case final value?) 'hard_delete': value,
  if (instance.deletedForMe case final value?) 'deleted_for_me': value,
  if (_$AITypingStateEnumMap[instance.aiState] case final value?) 'ai_state': value,
  if (instance.aiMessage case final value?) 'ai_message': value,
  if (instance.messageId case final value?) 'message_id': value,
  if (instance.thread?.toJson() case final value?) 'thread': value,
  if (instance.unreadThreadMessages case final value?) 'unread_thread_messages': value,
  if (instance.unreadThreads case final value?) 'unread_threads': value,
  if (instance.lastReadAt?.toIso8601String() case final value?) 'last_read_at': value,
  if (instance.unreadMessages case final value?) 'unread_messages': value,
  if (instance.lastReadMessageId case final value?) 'last_read_message_id': value,
  if (instance.draft?.toJson() case final value?) 'draft': value,
  if (instance.reminder?.toJson() case final value?) 'reminder': value,
  if (instance.pushPreference?.toJson() case final value?) 'push_preference': value,
  if (instance.channelPushPreference?.toJson() case final value?) 'channel_push_preference': value,
  if (instance.channelMessageCount case final value?) 'channel_message_count': value,
  if (instance.lastDeliveredAt?.toIso8601String() case final value?) 'last_delivered_at': value,
  if (instance.lastDeliveredMessageId case final value?) 'last_delivered_message_id': value,
  'extra_data': instance.extraData,
};

const _$AITypingStateEnumMap = {
  AITypingState.idle: 'AI_STATE_IDLE',
  AITypingState.error: 'AI_STATE_ERROR',
  AITypingState.checkingSources: 'AI_STATE_CHECKING_SOURCES',
  AITypingState.thinking: 'AI_STATE_THINKING',
  AITypingState.generating: 'AI_STATE_GENERATING',
};
