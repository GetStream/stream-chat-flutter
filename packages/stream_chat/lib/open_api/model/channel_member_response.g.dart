// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMemberResponse _$ChannelMemberResponseFromJson(
  Map<String, dynamic> json,
) => ChannelMemberResponse(
  archivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['archived_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  banExpires: _$JsonConverterFromJson<Object, DateTime>(
    json['ban_expires'],
    const StreamDateTimeConverter().fromJson,
  ),
  banFromFutureChannels: json['ban_from_future_channels'] as bool?,
  banned: json['banned'] as bool,
  channelRole: json['channel_role'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  deletedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['deleted_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  deletedMessages: (json['deleted_messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  futureChannelBanExpires: _$JsonConverterFromJson<Object, DateTime>(
    json['future_channel_ban_expires'],
    const StreamDateTimeConverter().fromJson,
  ),
  inviteAcceptedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['invite_accepted_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  inviteRejectedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['invite_rejected_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  invited: json['invited'] as bool?,
  isModerator: json['is_moderator'] as bool?,
  notificationsMuted: json['notifications_muted'] as bool,
  pinnedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['pinned_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  role: json['role'] as String?,
  shadowBanned: json['shadow_banned'] as bool,
  status: json['status'] as String?,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: json['user'] == null
      ? null
      : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$ChannelMemberResponseToJson(
  ChannelMemberResponse instance,
) => <String, dynamic>{
  'archived_at': _$JsonConverterToJson<Object, DateTime>(
    instance.archivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'ban_expires': _$JsonConverterToJson<Object, DateTime>(
    instance.banExpires,
    const StreamDateTimeConverter().toJson,
  ),
  'ban_from_future_channels': instance.banFromFutureChannels,
  'banned': instance.banned,
  'channel_role': instance.channelRole,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'deleted_at': _$JsonConverterToJson<Object, DateTime>(
    instance.deletedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'deleted_messages': instance.deletedMessages,
  'future_channel_ban_expires': _$JsonConverterToJson<Object, DateTime>(
    instance.futureChannelBanExpires,
    const StreamDateTimeConverter().toJson,
  ),
  'invite_accepted_at': _$JsonConverterToJson<Object, DateTime>(
    instance.inviteAcceptedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'invite_rejected_at': _$JsonConverterToJson<Object, DateTime>(
    instance.inviteRejectedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'invited': instance.invited,
  'is_moderator': instance.isModerator,
  'notifications_muted': instance.notificationsMuted,
  'pinned_at': _$JsonConverterToJson<Object, DateTime>(
    instance.pinnedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'role': instance.role,
  'shadow_banned': instance.shadowBanned,
  'status': instance.status,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user?.toJson(),
  'user_id': instance.userId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
