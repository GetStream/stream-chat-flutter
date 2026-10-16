// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnUser _$OwnUserFromJson(Map<String, dynamic> json) => OwnUser(
  devices:
      (json['devices'] as List<dynamic>?)
          ?.map((e) => const DeviceV1JsonConverter().fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  mutes: (json['mutes'] as List<dynamic>?)?.map((e) => Mute.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt() ?? 0,
  unreadChannels: (json['unread_channels'] as num?)?.toInt() ?? 0,
  channelMutes:
      (json['channel_mutes'] as List<dynamic>?)?.map((e) => ChannelMute.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  unreadThreads: (json['unread_threads'] as num?)?.toInt() ?? 0,
  blockedUserIds: (json['blocked_user_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  pushPreferences: json['push_preferences'] == null
      ? null
      : PushPreference.fromJson(json['push_preferences'] as Map<String, dynamic>),
  privacySettings: json['privacy_settings'] == null
      ? null
      : PrivacySettings.fromJson(json['privacy_settings'] as Map<String, dynamic>),
  unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
  totalUnreadCountByTeam: (json['total_unread_count_by_team'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  latestHiddenChannels: (json['latest_hidden_channels'] as List<dynamic>?)?.map((e) => e as String).toList(),
  id: json['id'] as String,
  role: json['role'] as String?,
  name: json['name'] as String?,
  image: json['image'] as String?,
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
  lastActive: json['last_active'] == null ? null : DateTime.parse(json['last_active'] as String),
  online: json['online'] as bool? ?? false,
  custom: json['extra_data'] as Map<String, dynamic>? ?? const {},
  banned: json['banned'] as bool? ?? false,
  banExpires: json['ban_expires'] == null ? null : DateTime.parse(json['ban_expires'] as String),
  teams: (json['teams'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  language: json['language'] as String?,
  invisible: json['invisible'] as bool?,
  teamsRole: (json['teams_role'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)),
  avgResponseTime: (json['avg_response_time'] as num?)?.toInt(),
  deactivatedAt: json['deactivated_at'] == null ? null : DateTime.parse(json['deactivated_at'] as String),
  deletedAt: json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at'] as String),
  shadowBanned: json['shadow_banned'] as bool?,
);

Map<String, dynamic> _$OwnUserToJson(OwnUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': ?instance.name,
  'image': ?instance.image,
  'role': ?instance.role,
  'teams': instance.teams,
  'created_at': ?instance.createdAt?.toIso8601String(),
  'updated_at': ?instance.updatedAt?.toIso8601String(),
  'last_active': ?instance.lastActive?.toIso8601String(),
  'online': instance.online,
  'banned': instance.banned,
  'ban_expires': ?instance.banExpires?.toIso8601String(),
  'language': ?instance.language,
  'invisible': ?instance.invisible,
  'teams_role': ?instance.teamsRole,
  'avg_response_time': ?instance.avgResponseTime,
  'extra_data': instance.custom,
  'deactivated_at': ?instance.deactivatedAt?.toIso8601String(),
  'deleted_at': ?instance.deletedAt?.toIso8601String(),
  'shadow_banned': ?instance.shadowBanned,
  'blocked_user_ids': instance.blockedUserIds,
  'devices': instance.devices.map(const DeviceV1JsonConverter().toJson).toList(),
  'mutes': instance.mutes.map((e) => e.toJson()).toList(),
  'channel_mutes': instance.channelMutes.map((e) => e.toJson()).toList(),
  'total_unread_count': instance.totalUnreadCount,
  'unread_channels': instance.unreadChannels,
  'unread_threads': instance.unreadThreads,
  'push_preferences': ?instance.pushPreferences?.toJson(),
  'privacy_settings': ?instance.privacySettings?.toJson(),
  'unread_count': instance.unreadCount,
  'total_unread_count_by_team': ?instance.totalUnreadCountByTeam,
  'latest_hidden_channels': ?instance.latestHiddenChannels,
};
