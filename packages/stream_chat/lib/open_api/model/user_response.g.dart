// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  avgResponseTime: (json['avg_response_time'] as num?)?.toInt(),
  banned: json['banned'] as bool,
  blockedUserIds: (json['blocked_user_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  deactivatedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['deactivated_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  deletedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['deleted_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  id: json['id'] as String,
  image: json['image'] as String?,
  language: json['language'] as String,
  lastActive: _$JsonConverterFromJson<Object, DateTime>(
    json['last_active'],
    const StreamDateTimeConverter().fromJson,
  ),
  name: json['name'] as String?,
  online: json['online'] as bool,
  revokeTokensIssuedBefore: _$JsonConverterFromJson<Object, DateTime>(
    json['revoke_tokens_issued_before'],
    const StreamDateTimeConverter().fromJson,
  ),
  role: json['role'] as String,
  teams: (json['teams'] as List<dynamic>).map((e) => e as String).toList(),
  teamsRole: (json['teams_role'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'avg_response_time': instance.avgResponseTime,
      'banned': instance.banned,
      'blocked_user_ids': instance.blockedUserIds,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'deactivated_at': _$JsonConverterToJson<Object, DateTime>(
        instance.deactivatedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'deleted_at': _$JsonConverterToJson<Object, DateTime>(
        instance.deletedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'id': instance.id,
      'image': instance.image,
      'language': instance.language,
      'last_active': _$JsonConverterToJson<Object, DateTime>(
        instance.lastActive,
        const StreamDateTimeConverter().toJson,
      ),
      'name': instance.name,
      'online': instance.online,
      'revoke_tokens_issued_before': _$JsonConverterToJson<Object, DateTime>(
        instance.revokeTokensIssuedBefore,
        const StreamDateTimeConverter().toJson,
      ),
      'role': instance.role,
      'teams': instance.teams,
      'teams_role': instance.teamsRole,
      'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
