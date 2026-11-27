// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  role: json['role'] as String?,
  name: json['name'] as String?,
  image: json['image'] as String?,
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
  lastActive: json['last_active'] == null ? null : DateTime.parse(json['last_active'] as String),
  online: json['online'] as bool? ?? false,
  banned: json['banned'] as bool? ?? false,
  banExpires: json['ban_expires'] == null ? null : DateTime.parse(json['ban_expires'] as String),
  teams: (json['teams'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  language: json['language'] as String?,
  invisible: json['invisible'] as bool?,
  teamsRole: (json['teams_role'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  avgResponseTime: (json['avg_response_time'] as num?)?.toInt(),
  custom: json['extra_data'] as Map<String, dynamic>? ?? const {},
  deactivatedAt: json['deactivated_at'] == null ? null : DateTime.parse(json['deactivated_at'] as String),
  deletedAt: json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at'] as String),
  shadowBanned: json['shadow_banned'] as bool?,
  blockedUserIds: (json['blocked_user_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
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
};
