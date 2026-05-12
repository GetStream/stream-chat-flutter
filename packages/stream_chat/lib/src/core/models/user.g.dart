// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  role: json['role'] as String?,
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
  extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
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
  'extra_data': instance.extraData,
};
