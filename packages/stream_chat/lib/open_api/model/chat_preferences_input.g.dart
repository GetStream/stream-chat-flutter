// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_preferences_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatPreferencesInput _$ChatPreferencesInputFromJson(
  Map<String, dynamic> json,
) => ChatPreferencesInput(
  channelMentions: json['channel_mentions'] == null
      ? null
      : ChatPreferencesInputChannelMentions.fromJson(
          json['channel_mentions'] as String,
        ),
  defaultPreference: json['default_preference'] == null
      ? null
      : ChatPreferencesInputDefaultPreference.fromJson(
          json['default_preference'] as String,
        ),
  directMentions: json['direct_mentions'] == null
      ? null
      : ChatPreferencesInputDirectMentions.fromJson(
          json['direct_mentions'] as String,
        ),
  groupMentions: json['group_mentions'] == null
      ? null
      : ChatPreferencesInputGroupMentions.fromJson(
          json['group_mentions'] as String,
        ),
  hereMentions: json['here_mentions'] == null
      ? null
      : ChatPreferencesInputHereMentions.fromJson(
          json['here_mentions'] as String,
        ),
  roleMentions: json['role_mentions'] == null
      ? null
      : ChatPreferencesInputRoleMentions.fromJson(
          json['role_mentions'] as String,
        ),
  threadReplies: json['thread_replies'] == null
      ? null
      : ChatPreferencesInputThreadReplies.fromJson(
          json['thread_replies'] as String,
        ),
);

Map<String, dynamic> _$ChatPreferencesInputToJson(
  ChatPreferencesInput instance,
) => <String, dynamic>{
  'channel_mentions': instance.channelMentions?.toJson(),
  'default_preference': instance.defaultPreference?.toJson(),
  'direct_mentions': instance.directMentions?.toJson(),
  'group_mentions': instance.groupMentions?.toJson(),
  'here_mentions': instance.hereMentions?.toJson(),
  'role_mentions': instance.roleMentions?.toJson(),
  'thread_replies': instance.threadReplies?.toJson(),
};
