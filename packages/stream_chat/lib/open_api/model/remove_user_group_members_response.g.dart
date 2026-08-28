// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_user_group_members_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveUserGroupMembersResponse _$RemoveUserGroupMembersResponseFromJson(
  Map<String, dynamic> json,
) => RemoveUserGroupMembersResponse(
  duration: json['duration'] as String,
  userGroup: json['user_group'] == null
      ? null
      : UserGroupResponse.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RemoveUserGroupMembersResponseToJson(
  RemoveUserGroupMembersResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'user_group': instance.userGroup?.toJson(),
};
