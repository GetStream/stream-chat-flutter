// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banned_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannedUser _$BannedUserFromJson(Map<String, dynamic> json) => BannedUser(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      bannedBy: json['banned_by'] == null
          ? null
          : User.fromJson(json['banned_by'] as Map<String, dynamic>),
      channel: json['channel'] == null
          ? null
          : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      expires: json['expires'] == null
          ? null
          : DateTime.parse(json['expires'] as String),
      shadow: json['shadow'] as bool? ?? false,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$BannedUserToJson(BannedUser instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'banned_by': instance.bannedBy?.toJson(),
      'channel': instance.channel?.toJson(),
      'created_at': instance.createdAt?.toIso8601String(),
      'expires': instance.expires?.toIso8601String(),
      'shadow': instance.shadow,
      'reason': instance.reason,
    };
