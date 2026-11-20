// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_channel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateChannelResponse _$UpdateChannelResponseFromJson(
  Map<String, dynamic> json,
) => UpdateChannelResponse(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  duration: json['duration'] as String,
  members: (json['members'] as List<dynamic>)
      .map((e) => ChannelMemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateChannelResponseToJson(
  UpdateChannelResponse instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'duration': instance.duration,
  'members': instance.members.map((e) => e.toJson()).toList(),
  'message': instance.message?.toJson(),
};
