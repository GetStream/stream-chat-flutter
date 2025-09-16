// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      inviteAcceptedAt: json['invite_accepted_at'] == null
          ? null
          : DateTime.parse(json['invite_accepted_at'] as String),
      inviteRejectedAt: json['invite_rejected_at'] == null
          ? null
          : DateTime.parse(json['invite_rejected_at'] as String),
      invited: json['invited'] as bool? ?? false,
      channelRole: json['channel_role'] as String?,
      userId: json['user_id'] as String?,
      isModerator: json['is_moderator'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      banned: json['banned'] as bool? ?? false,
      banExpires: json['ban_expires'] == null
          ? null
          : DateTime.parse(json['ban_expires'] as String),
      shadowBanned: json['shadow_banned'] as bool? ?? false,
      pinnedAt: json['pinned_at'] == null
          ? null
          : DateTime.parse(json['pinned_at'] as String),
      archivedAt: json['archived_at'] == null
          ? null
          : DateTime.parse(json['archived_at'] as String),
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'user': instance.user?.toJson(),
      'invite_accepted_at': instance.inviteAcceptedAt?.toIso8601String(),
      'invite_rejected_at': instance.inviteRejectedAt?.toIso8601String(),
      'invited': instance.invited,
      'channel_role': instance.channelRole,
      'user_id': instance.userId,
      'is_moderator': instance.isModerator,
      'banned': instance.banned,
      'ban_expires': instance.banExpires?.toIso8601String(),
      'shadow_banned': instance.shadowBanned,
      'pinned_at': instance.pinnedAt?.toIso8601String(),
      'archived_at': instance.archivedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'extra_data': instance.extraData,
    };
