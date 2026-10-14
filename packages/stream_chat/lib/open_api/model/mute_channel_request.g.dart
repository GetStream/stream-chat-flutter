// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteChannelRequest _$MuteChannelRequestFromJson(Map<String, dynamic> json) => MuteChannelRequest(
  channelCids: (json['channel_cids'] as List<dynamic>?)?.map((e) => e as String).toList(),
  expiration: (json['expiration'] as num?)?.toInt(),
);

Map<String, dynamic> _$MuteChannelRequestToJson(MuteChannelRequest instance) => <String, dynamic>{
  'channel_cids': instance.channelCids,
  'expiration': instance.expiration,
};
