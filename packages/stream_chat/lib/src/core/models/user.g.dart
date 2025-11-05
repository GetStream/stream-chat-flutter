// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
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
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
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
    };
