// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_user_group_members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddUserGroupMembersResponse _$AddUserGroupMembersResponseFromJson(
  Map<String, dynamic> json,
) => AddUserGroupMembersResponse(
  duration: json['duration'] as String,
  userGroup: json['user_group'] == null
      ? null
      : UserGroupResponse.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AddUserGroupMembersResponseToJson(
  AddUserGroupMembersResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'user_group': instance.userGroup?.toJson(),
};
