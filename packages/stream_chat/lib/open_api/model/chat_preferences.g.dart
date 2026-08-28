// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPreferences _$ChatPreferencesFromJson(Map<String, dynamic> json) =>
    ChatPreferences(
      channelMentions: json['channel_mentions'] as String?,
      defaultPreference: json['default_preference'] as String?,
      directMentions: json['direct_mentions'] as String?,
      distinctChannelMessages: json['distinct_channel_messages'] as String?,
      groupMentions: json['group_mentions'] as String?,
      hereMentions: json['here_mentions'] as String?,
      roleMentions: json['role_mentions'] as String?,
      threadReplies: json['thread_replies'] as String?,
    );

Map<String, dynamic> _$ChatPreferencesToJson(ChatPreferences instance) =>
    <String, dynamic>{
      'channel_mentions': instance.channelMentions,
      'default_preference': instance.defaultPreference,
      'direct_mentions': instance.directMentions,
      'distinct_channel_messages': instance.distinctChannelMessages,
      'group_mentions': instance.groupMentions,
      'here_mentions': instance.hereMentions,
      'role_mentions': instance.roleMentions,
      'thread_replies': instance.threadReplies,
    };
