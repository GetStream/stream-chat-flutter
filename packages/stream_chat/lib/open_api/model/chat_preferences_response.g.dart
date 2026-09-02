// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_preferences_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPreferencesResponse _$ChatPreferencesResponseFromJson(
  Map<String, dynamic> json,
) => ChatPreferencesResponse(
  channelMentions: json['channel_mentions'] as String?,
  defaultPreference: json['default_preference'] as String?,
  directMentions: json['direct_mentions'] as String?,
  groupMentions: json['group_mentions'] as String?,
  hereMentions: json['here_mentions'] as String?,
  roleMentions: json['role_mentions'] as String?,
  threadReplies: json['thread_replies'] as String?,
);

Map<String, dynamic> _$ChatPreferencesResponseToJson(
  ChatPreferencesResponse instance,
) => <String, dynamic>{
  'channel_mentions': instance.channelMentions,
  'default_preference': instance.defaultPreference,
  'direct_mentions': instance.directMentions,
  'group_mentions': instance.groupMentions,
  'here_mentions': instance.hereMentions,
  'role_mentions': instance.roleMentions,
  'thread_replies': instance.threadReplies,
};
