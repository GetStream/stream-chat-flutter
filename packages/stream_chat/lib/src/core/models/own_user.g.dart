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
      unreadThreads: (json['unread_threads'] as num?)?.toInt() ?? 0,
      blockedUserIds: (json['blocked_user_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pushPreferences: json['push_preferences'] == null
          ? null
          : PushPreference.fromJson(
              json['push_preferences'] as Map<String, dynamic>),
      privacySettings: json['privacy_settings'] == null
          ? null
          : PrivacySettings.fromJson(
              json['privacy_settings'] as Map<String, dynamic>),
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
      teamsRole: (json['teams_role'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      avgResponseTime: (json['avg_response_time'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OwnUserToJson(OwnUser instance) => <String, dynamic>{
      'id': instance.id,
      if (instance.role case final value?) 'role': value,
      'teams': instance.teams,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
      if (instance.lastActive?.toIso8601String() case final value?)
        'last_active': value,
      'online': instance.online,
      'banned': instance.banned,
      if (instance.banExpires?.toIso8601String() case final value?)
        'ban_expires': value,
      if (instance.language case final value?) 'language': value,
      if (instance.teamsRole case final value?) 'teams_role': value,
      if (instance.avgResponseTime case final value?)
        'avg_response_time': value,
      'extra_data': instance.extraData,
      'devices': instance.devices.map((e) => e.toJson()).toList(),
      'mutes': instance.mutes.map((e) => e.toJson()).toList(),
      'channel_mutes': instance.channelMutes.map((e) => e.toJson()).toList(),
      'total_unread_count': instance.totalUnreadCount,
      'unread_channels': instance.unreadChannels,
      'unread_threads': instance.unreadThreads,
      'blocked_user_ids': instance.blockedUserIds,
      if (instance.pushPreferences?.toJson() case final value?)
        'push_preferences': value,
      if (instance.privacySettings?.toJson() case final value?)
        'privacy_settings': value,
    };
