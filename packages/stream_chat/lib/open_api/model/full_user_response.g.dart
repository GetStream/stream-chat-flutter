// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullUserResponse _$FullUserResponseFromJson(Map<String, dynamic> json) =>
    FullUserResponse(
      avgResponseTime: (json['avg_response_time'] as num?)?.toInt(),
      banExpires: _$JsonConverterFromJson<Object, DateTime>(
        json['ban_expires'],
        const StreamDateTimeConverter().fromJson,
      ),
      banned: json['banned'] as bool,
      blockedUserIds: (json['blocked_user_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      channelMutes: (json['channel_mutes'] as List<dynamic>)
          .map((e) => ChannelMute.fromJson(e as Map<String, dynamic>))
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
      devices: (json['devices'] as List<dynamic>)
          .map((e) => DeviceResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
      image: json['image'] as String?,
      invisible: json['invisible'] as bool,
      language: json['language'] as String,
      lastActive: _$JsonConverterFromJson<Object, DateTime>(
        json['last_active'],
        const StreamDateTimeConverter().fromJson,
      ),
      latestHiddenChannels: (json['latest_hidden_channels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mutes: (json['mutes'] as List<dynamic>)
          .map((e) => UserMuteResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      online: json['online'] as bool,
      privacySettings: json['privacy_settings'] == null
          ? null
          : PrivacySettingsResponse.fromJson(
              json['privacy_settings'] as Map<String, dynamic>,
            ),
      revokeTokensIssuedBefore: _$JsonConverterFromJson<Object, DateTime>(
        json['revoke_tokens_issued_before'],
        const StreamDateTimeConverter().fromJson,
      ),
      role: json['role'] as String,
      shadowBanned: json['shadow_banned'] as bool,
      teams: (json['teams'] as List<dynamic>).map((e) => e as String).toList(),
      teamsRole: (json['teams_role'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      totalUnreadCount: (json['total_unread_count'] as num).toInt(),
      unreadChannels: (json['unread_channels'] as num).toInt(),
      unreadCount: (json['unread_count'] as num).toInt(),
      unreadThreads: (json['unread_threads'] as num).toInt(),
      updatedAt: const StreamDateTimeConverter().fromJson(
        json['updated_at'] as Object,
      ),
    );

Map<String, dynamic> _$FullUserResponseToJson(FullUserResponse instance) =>
    <String, dynamic>{
      'avg_response_time': instance.avgResponseTime,
      'ban_expires': _$JsonConverterToJson<Object, DateTime>(
        instance.banExpires,
        const StreamDateTimeConverter().toJson,
      ),
      'banned': instance.banned,
      'blocked_user_ids': instance.blockedUserIds,
      'channel_mutes': instance.channelMutes.map((e) => e.toJson()).toList(),
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
      'devices': instance.devices.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'image': instance.image,
      'invisible': instance.invisible,
      'language': instance.language,
      'last_active': _$JsonConverterToJson<Object, DateTime>(
        instance.lastActive,
        const StreamDateTimeConverter().toJson,
      ),
      'latest_hidden_channels': instance.latestHiddenChannels,
      'mutes': instance.mutes.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'online': instance.online,
      'privacy_settings': instance.privacySettings?.toJson(),
      'revoke_tokens_issued_before': _$JsonConverterToJson<Object, DateTime>(
        instance.revokeTokensIssuedBefore,
        const StreamDateTimeConverter().toJson,
      ),
      'role': instance.role,
      'shadow_banned': instance.shadowBanned,
      'teams': instance.teams,
      'teams_role': instance.teamsRole,
      'total_unread_count': instance.totalUnreadCount,
      'unread_channels': instance.unreadChannels,
      'unread_count': instance.unreadCount,
      'unread_threads': instance.unreadThreads,
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
