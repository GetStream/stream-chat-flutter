// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnUser _$OwnUserFromJson(Map<String, dynamic> json) => OwnUser(
      devices: (json['devices'] as List<dynamic>?)
              ?.map((e) => Device.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      mutes: (json['mutes'] as List<dynamic>?)
              ?.map((e) => Mute.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalUnreadCount: (json['total_unread_count'] as num?)?.toInt() ?? 0,
      unreadChannels: (json['unread_channels'] as num?)?.toInt() ?? 0,
      channelMutes: (json['channel_mutes'] as List<dynamic>?)
              ?.map((e) => ChannelMute.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      id: json['id'] as String,
      role: json['role'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      lastActive: json['last_active'] == null
          ? null
          : DateTime.parse(json['last_active'] as String),
      online: json['online'] as bool? ?? false,
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      banned: json['banned'] as bool? ?? false,
      banExpires: json['ban_expires'] == null
          ? null
          : DateTime.parse(json['ban_expires'] as String),
      teams:
          (json['teams'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      language: json['language'] as String?,
    );
