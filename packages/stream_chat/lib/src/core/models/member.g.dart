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
      role: json['role'] as String?,
      userId: json['user_id'] as String?,
      isModerator: json['is_moderator'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      banned: json['banned'] as bool? ?? false,
      shadowBanned: json['shadow_banned'] as bool? ?? false,
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'user': instance.user?.toJson(),
      'invite_accepted_at': instance.inviteAcceptedAt?.toIso8601String(),
      'invite_rejected_at': instance.inviteRejectedAt?.toIso8601String(),
      'invited': instance.invited,
      'role': instance.role,
      'user_id': instance.userId,
      'is_moderator': instance.isModerator,
      'banned': instance.banned,
      'shadow_banned': instance.shadowBanned,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
