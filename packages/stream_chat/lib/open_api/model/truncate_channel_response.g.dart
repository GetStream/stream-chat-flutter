// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truncate_channel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TruncateChannelResponse _$TruncateChannelResponseFromJson(
  Map<String, dynamic> json,
) => TruncateChannelResponse(
  channel: json['channel'] == null
      ? null
      : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  duration: json['duration'] as String,
  message: json['message'] == null
      ? null
      : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TruncateChannelResponseToJson(
  TruncateChannelResponse instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'duration': instance.duration,
  'message': instance.message?.toJson(),
};
