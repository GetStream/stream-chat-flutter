// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_member_partial_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMemberPartialResponse _$ChannelMemberPartialResponseFromJson(
  Map<String, dynamic> json,
) => ChannelMemberPartialResponse(
  channelRole: json['channel_role'] as String,
  custom: json['custom'] as Map<String, dynamic>?,
  notificationsMuted: json['notifications_muted'] as bool,
);

Map<String, dynamic> _$ChannelMemberPartialResponseToJson(
  ChannelMemberPartialResponse instance,
) => <String, dynamic>{
  'channel_role': instance.channelRole,
  'custom': instance.custom,
  'notifications_muted': instance.notificationsMuted,
};
