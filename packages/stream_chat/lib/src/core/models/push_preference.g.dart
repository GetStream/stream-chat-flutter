// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PushPreferenceInputToJson(
        PushPreferenceInput instance) =>
    <String, dynamic>{
      if (instance.channelCid case final value?) 'channel_cid': value,
      if (instance.callLevel case final value?) 'call_level': value,
      if (instance.chatLevel case final value?) 'chat_level': value,
      if (instance.disabledUntil?.toIso8601String() case final value?)
        'disabled_until': value,
      if (instance.removeDisable case final value?) 'remove_disable': value,
    };

PushPreference _$PushPreferenceFromJson(Map<String, dynamic> json) =>
    PushPreference(
      callLevel: json['call_level'] as CallLevel?,
      chatLevel: json['chat_level'] as ChatLevel?,
      disabledUntil: json['disabled_until'] == null
          ? null
          : DateTime.parse(json['disabled_until'] as String),
    );

Map<String, dynamic> _$PushPreferenceToJson(PushPreference instance) =>
    <String, dynamic>{
      if (instance.callLevel case final value?) 'call_level': value,
      if (instance.chatLevel case final value?) 'chat_level': value,
      if (instance.disabledUntil?.toIso8601String() case final value?)
        'disabled_until': value,
    };

ChannelPushPreference _$ChannelPushPreferenceFromJson(
        Map<String, dynamic> json) =>
    ChannelPushPreference(
      chatLevel: json['chat_level'] as ChatLevel?,
      disabledUntil: json['disabled_until'] == null
          ? null
          : DateTime.parse(json['disabled_until'] as String),
    );

Map<String, dynamic> _$ChannelPushPreferenceToJson(
        ChannelPushPreference instance) =>
    <String, dynamic>{
      if (instance.chatLevel case final value?) 'chat_level': value,
      if (instance.disabledUntil?.toIso8601String() case final value?)
        'disabled_until': value,
    };
