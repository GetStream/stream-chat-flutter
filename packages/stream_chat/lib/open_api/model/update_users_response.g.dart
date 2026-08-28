// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUsersResponse _$UpdateUsersResponseFromJson(Map<String, dynamic> json) => UpdateUsersResponse(
  duration: json['duration'] as String,
  membershipDeletionTaskId: json['membership_deletion_task_id'] as String,
  users: (json['users'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, FullUserResponse.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$UpdateUsersResponseToJson(
  UpdateUsersResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'membership_deletion_task_id': instance.membershipDeletionTaskId,
  'users': instance.users.map((k, e) => MapEntry(k, e.toJson())),
};
