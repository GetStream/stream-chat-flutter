// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_ban_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelBanResponse _$ChannelBanResponseFromJson(Map<String, dynamic> json) => ChannelBanResponse(
  channelBan: json['channel_ban'] == null
      ? null
      : ChannelBanScopeResponse.fromJson(
          json['channel_ban'] as Map<String, dynamic>,
        ),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  futureChannelBan: json['future_channel_ban'] == null
      ? null
      : ChannelBanScopeResponse.fromJson(
          json['future_channel_ban'] as Map<String, dynamic>,
        ),
  scopes: (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
  user: json['user'] == null ? null : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelBanResponseToJson(ChannelBanResponse instance) => <String, dynamic>{
  'channel_ban': instance.channelBan?.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'future_channel_ban': instance.futureChannelBan?.toJson(),
  'scopes': instance.scopes,
  'user': instance.user?.toJson(),
};
