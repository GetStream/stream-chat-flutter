// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      type: json['type'] as String? ?? 'local.event',
      cid: json['cid'] as String?,
      connectionId: json['connection_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      me: json['me'] == null
          ? null
          : OwnUser.fromJson(json['me'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map<String, dynamic>),
      poll: json['poll'] == null
          ? null
          : Poll.fromJson(json['poll'] as Map<String, dynamic>),
      pollVote: json['poll_vote'] == null
          ? null
          : PollVote.fromJson(json['poll_vote'] as Map<String, dynamic>),
      totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
      unreadChannels: (json['unread_channels'] as num?)?.toInt(),
      reaction: json['reaction'] == null
          ? null
          : Reaction.fromJson(json['reaction'] as Map<String, dynamic>),
      online: json['online'] as bool?,
      channel: json['channel'] == null
          ? null
          : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
      member: json['member'] == null
          ? null
          : Member.fromJson(json['member'] as Map<String, dynamic>),
      channelId: json['channel_id'] as String?,
      channelType: json['channel_type'] as String?,
      channelLastMessageAt: json['channel_last_message_at'] == null
          ? null
          : DateTime.parse(json['channel_last_message_at'] as String),
      parentId: json['parent_id'] as String?,
      hardDelete: json['hard_delete'] as bool?,
      aiState: $enumDecodeNullable(_$AITypingStateEnumMap, json['ai_state'],
          unknownValue: AITypingState.idle),
      aiMessage: json['ai_message'] as String?,
      messageId: json['message_id'] as String?,
      thread: json['thread'] == null
          ? null
          : Thread.fromJson(json['thread'] as Map<String, dynamic>),
      unreadThreadMessages: (json['unread_thread_messages'] as num?)?.toInt(),
      unreadThreads: (json['unread_threads'] as num?)?.toInt(),
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      isLocal: json['is_local'] as bool? ?? false,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'type': instance.type,
      'cid': instance.cid,
      'channel_id': instance.channelId,
      'channel_type': instance.channelType,
      'channel_last_message_at':
          instance.channelLastMessageAt?.toIso8601String(),
      'connection_id': instance.connectionId,
      'created_at': instance.createdAt.toIso8601String(),
      'me': instance.me?.toJson(),
      'user': instance.user?.toJson(),
      'message': instance.message?.toJson(),
      'poll': instance.poll?.toJson(),
      'poll_vote': instance.pollVote?.toJson(),
      'channel': instance.channel?.toJson(),
      'member': instance.member?.toJson(),
      'reaction': instance.reaction?.toJson(),
      'total_unread_count': instance.totalUnreadCount,
      'unread_channels': instance.unreadChannels,
      'online': instance.online,
      'parent_id': instance.parentId,
      'is_local': instance.isLocal,
      if (instance.hardDelete case final value?) 'hard_delete': value,
      'ai_state': _$AITypingStateEnumMap[instance.aiState],
      'ai_message': instance.aiMessage,
      'message_id': instance.messageId,
      'thread': instance.thread?.toJson(),
      'unread_thread_messages': instance.unreadThreadMessages,
      'unread_threads': instance.unreadThreads,
      'extra_data': instance.extraData,
    };

const _$AITypingStateEnumMap = {
  AITypingState.idle: 'AI_STATE_IDLE',
  AITypingState.error: 'AI_STATE_ERROR',
  AITypingState.checkingSources: 'AI_STATE_CHECKING_SOURCES',
  AITypingState.thinking: 'AI_STATE_THINKING',
  AITypingState.generating: 'AI_STATE_GENERATING',
};
