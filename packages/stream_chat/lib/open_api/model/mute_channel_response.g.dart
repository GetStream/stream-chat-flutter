// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_channel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteChannelResponse _$MuteChannelResponseFromJson(Map<String, dynamic> json) => MuteChannelResponse(
  channelMute: json['channel_mute'] == null ? null : ChannelMute.fromJson(json['channel_mute'] as Map<String, dynamic>),
  channelMutes: (json['channel_mutes'] as List<dynamic>?)
      ?.map((e) => ChannelMute.fromJson(e as Map<String, dynamic>))
      .toList(),
  duration: json['duration'] as String,
  ownUser: json['own_user'] == null ? null : OwnUserResponse.fromJson(json['own_user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MuteChannelResponseToJson(
  MuteChannelResponse instance,
) => <String, dynamic>{
  'channel_mute': instance.channelMute?.toJson(),
  'channel_mutes': instance.channelMutes?.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
  'own_user': instance.ownUser?.toJson(),
};
