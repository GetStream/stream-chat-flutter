// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMute _$ChannelMuteFromJson(Map<String, dynamic> json) => ChannelMute(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      channel: ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      expires: json['expires'] == null
          ? null
          : DateTime.parse(json['expires'] as String),
    );

Map<String, dynamic> _$ChannelMuteToJson(ChannelMute instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'channel': instance.channel.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'expires': instance.expires?.toIso8601String(),
    };
