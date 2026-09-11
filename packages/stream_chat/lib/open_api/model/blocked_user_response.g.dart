// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockedUserResponse _$BlockedUserResponseFromJson(Map<String, dynamic> json) => BlockedUserResponse(
  blockedUser: UserResponse.fromJson(
    json['blocked_user'] as Map<String, dynamic>,
  ),
  blockedUserId: json['blocked_user_id'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$BlockedUserResponseToJson(
  BlockedUserResponse instance,
) => <String, dynamic>{
  'blocked_user': instance.blockedUser.toJson(),
  'blocked_user_id': instance.blockedUserId,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'user': instance.user.toJson(),
  'user_id': instance.userId,
};
