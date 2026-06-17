// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPreferences _$ChatPreferencesFromJson(Map<String, dynamic> json) => ChatPreferences(
  channelMentions: json['channel_mentions'] as ChatPreferenceLevel?,
  defaultPreference: json['default_preference'] as ChatPreferenceLevel?,
  directMentions: json['direct_mentions'] as ChatPreferenceLevel?,
  groupMentions: json['group_mentions'] as ChatPreferenceLevel?,
  hereMentions: json['here_mentions'] as ChatPreferenceLevel?,
  roleMentions: json['role_mentions'] as ChatPreferenceLevel?,
  threadReplies: json['thread_replies'] as ChatPreferenceLevel?,
);

Map<String, dynamic> _$ChatPreferencesToJson(ChatPreferences instance) => <String, dynamic>{
  'channel_mentions': ?instance.channelMentions,
  'default_preference': ?instance.defaultPreference,
  'direct_mentions': ?instance.directMentions,
  'group_mentions': ?instance.groupMentions,
  'here_mentions': ?instance.hereMentions,
  'role_mentions': ?instance.roleMentions,
  'thread_replies': ?instance.threadReplies,
};
