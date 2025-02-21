// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBlock _$UserBlockFromJson(Map<String, dynamic> json) => UserBlock(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      blockedUser: json['blocked_user'] == null
          ? null
          : User.fromJson(json['blocked_user'] as Map<String, dynamic>),
      userId: json['user_id'] as String?,
      blockedUserId: json['blocked_user_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$UserBlockToJson(UserBlock instance) => <String, dynamic>{
      'user': instance.user.toJson(),
      'blocked_user': instance.blockedUser?.toJson(),
      'user_id': instance.userId,
      'blocked_user_id': instance.blockedUserId,
      'created_at': instance.createdAt?.toIso8601String(),
    };
