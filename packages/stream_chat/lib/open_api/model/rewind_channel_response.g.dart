// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewind_channel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewindChannelResponse _$RewindChannelResponseFromJson(
  Map<String, dynamic> json,
) => RewindChannelResponse(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  duration: json['duration'] as String,
  rewind: ChannelRewindResponse.fromJson(
    json['rewind'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$RewindChannelResponseToJson(
  RewindChannelResponse instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'duration': instance.duration,
  'rewind': instance.rewind.toJson(),
};
