// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_channel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteChannelResponse _$DeleteChannelResponseFromJson(
  Map<String, dynamic> json,
) => DeleteChannelResponse(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$DeleteChannelResponseToJson(
  DeleteChannelResponse instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'duration': instance.duration,
};
