// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PushPreferenceInputToJson(
        PushPreferenceInput instance) =>
    <String, dynamic>{
      if (instance.channelCid case final value?) 'channel_cid': value,
      if (_$CallLevelPushPreferenceEnumMap[instance.callLevel]
          case final value?)
        'call_level': value,
      if (_$ChatLevelPushPreferenceEnumMap[instance.chatLevel]
          case final value?)
        'chat_level': value,
      if (instance.disabledUntil?.toIso8601String() case final value?)
        'disabled_until': value,
      if (instance.removeDisable case final value?) 'remove_disable': value,
    };

const _$CallLevelPushPreferenceEnumMap = {
  CallLevelPushPreference.all: 'all',
  CallLevelPushPreference.none: 'none',
  CallLevelPushPreference.defaultValue: 'default',
};

const _$ChatLevelPushPreferenceEnumMap = {
  ChatLevelPushPreference.all: 'all',
  ChatLevelPushPreference.none: 'none',
  ChatLevelPushPreference.mentions: 'mentions',
  ChatLevelPushPreference.defaultValue: 'default',
};

PushPreference _$PushPreferenceFromJson(Map<String, dynamic> json) =>
    PushPreference(
      callLevel: $enumDecodeNullable(
          _$CallLevelPushPreferenceEnumMap, json['call_level']),
      chatLevel: $enumDecodeNullable(
          _$ChatLevelPushPreferenceEnumMap, json['chat_level']),
      disabledUntil: json['disabled_until'] == null
          ? null
          : DateTime.parse(json['disabled_until'] as String),
    );

Map<String, dynamic> _$PushPreferenceToJson(PushPreference instance) =>
    <String, dynamic>{
      if (_$CallLevelPushPreferenceEnumMap[instance.callLevel]
          case final value?)
        'call_level': value,
      if (_$ChatLevelPushPreferenceEnumMap[instance.chatLevel]
          case final value?)
        'chat_level': value,
      if (instance.disabledUntil?.toIso8601String() case final value?)
        'disabled_until': value,
    };

ChannelPushPreference _$ChannelPushPreferenceFromJson(
        Map<String, dynamic> json) =>
    ChannelPushPreference(
      chatLevel: $enumDecodeNullable(
          _$ChatLevelPushPreferenceEnumMap, json['chat_level']),
      disabledUntil: json['disabled_until'] == null
          ? null
          : DateTime.parse(json['disabled_until'] as String),
    );

Map<String, dynamic> _$ChannelPushPreferenceToJson(
        ChannelPushPreference instance) =>
    <String, dynamic>{
      if (_$ChatLevelPushPreferenceEnumMap[instance.chatLevel]
          case final value?)
        'chat_level': value,
      if (instance.disabledUntil?.toIso8601String() case final value?)
        'disabled_until': value,
    };
