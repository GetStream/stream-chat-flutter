// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unmute_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnmuteChannelRequest _$UnmuteChannelRequestFromJson(
  Map<String, dynamic> json,
) => UnmuteChannelRequest(
  channelCids: (json['channel_cids'] as List<dynamic>?)?.map((e) => e as String).toList(),
  expiration: (json['expiration'] as num?)?.toInt(),
);

Map<String, dynamic> _$UnmuteChannelRequestToJson(
  UnmuteChannelRequest instance,
) => <String, dynamic>{
  'channel_cids': instance.channelCids,
  'expiration': instance.expiration,
};
