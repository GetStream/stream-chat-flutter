// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_preferences_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPreferencesInput _$ChatPreferencesInputFromJson(
  Map<String, dynamic> json,
) => ChatPreferencesInput(
  channelMentions: json['channel_mentions'] as ChatPreferencesInputChannelMentions?,
  defaultPreference: json['default_preference'] as ChatPreferencesInputDefaultPreference?,
  directMentions: json['direct_mentions'] as ChatPreferencesInputDirectMentions?,
  groupMentions: json['group_mentions'] as ChatPreferencesInputGroupMentions?,
  hereMentions: json['here_mentions'] as ChatPreferencesInputHereMentions?,
  roleMentions: json['role_mentions'] as ChatPreferencesInputRoleMentions?,
  threadReplies: json['thread_replies'] as ChatPreferencesInputThreadReplies?,
);

Map<String, dynamic> _$ChatPreferencesInputToJson(
  ChatPreferencesInput instance,
) => <String, dynamic>{
  'channel_mentions': instance.channelMentions,
  'default_preference': instance.defaultPreference,
  'direct_mentions': instance.directMentions,
  'group_mentions': instance.groupMentions,
  'here_mentions': instance.hereMentions,
  'role_mentions': instance.roleMentions,
  'thread_replies': instance.threadReplies,
};
