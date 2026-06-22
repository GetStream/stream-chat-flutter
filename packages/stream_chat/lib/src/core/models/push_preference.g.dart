// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PushPreferenceInputToJson(
  PushPreferenceInput instance,
) => <String, dynamic>{
  'channel_cid': ?instance.channelCid,
  'call_level': ?instance.callLevel,
  'chat_level': ?instance.chatLevel,
  'chat_preferences': ?instance.chatPreferences?.toJson(),
  'disabled_until': ?instance.disabledUntil?.toIso8601String(),
  'remove_disable': ?instance.removeDisable,
};

PushPreference _$PushPreferenceFromJson(Map<String, dynamic> json) => PushPreference(
  callLevel: json['call_level'] as CallLevel?,
  chatLevel: json['chat_level'] as ChatLevel?,
  chatPreferences: json['chat_preferences'] == null
      ? null
      : ChatPreferences.fromJson(
          json['chat_preferences'] as Map<String, dynamic>,
        ),
  disabledUntil: json['disabled_until'] == null ? null : DateTime.parse(json['disabled_until'] as String),
);

Map<String, dynamic> _$PushPreferenceToJson(PushPreference instance) => <String, dynamic>{
  'call_level': ?instance.callLevel,
  'chat_level': ?instance.chatLevel,
  'chat_preferences': ?instance.chatPreferences?.toJson(),
  'disabled_until': ?instance.disabledUntil?.toIso8601String(),
};

ChannelPushPreference _$ChannelPushPreferenceFromJson(
  Map<String, dynamic> json,
) => ChannelPushPreference(
  chatLevel: json['chat_level'] as ChatLevel?,
  chatPreferences: json['chat_preferences'] == null
      ? null
      : ChatPreferences.fromJson(
          json['chat_preferences'] as Map<String, dynamic>,
        ),
  disabledUntil: json['disabled_until'] == null ? null : DateTime.parse(json['disabled_until'] as String),
);

Map<String, dynamic> _$ChannelPushPreferenceToJson(
  ChannelPushPreference instance,
) => <String, dynamic>{
  'chat_level': ?instance.chatLevel,
  'chat_preferences': ?instance.chatPreferences?.toJson(),
  'disabled_until': ?instance.disabledUntil?.toIso8601String(),
};
