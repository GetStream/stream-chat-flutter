// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_channel_partial_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateChannelPartialResponse _$UpdateChannelPartialResponseFromJson(
  Map<String, dynamic> json,
) => UpdateChannelPartialResponse(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  duration: json['duration'] as String,
  members: (json['members'] as List<dynamic>)
      .map((e) => ChannelMemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpdateChannelPartialResponseToJson(
  UpdateChannelPartialResponse instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'duration': instance.duration,
  'members': instance.members.map((e) => e.toJson()).toList(),
};
