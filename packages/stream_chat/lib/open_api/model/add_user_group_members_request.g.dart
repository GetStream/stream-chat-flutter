// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_user_group_members_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddUserGroupMembersRequest _$AddUserGroupMembersRequestFromJson(
  Map<String, dynamic> json,
) => AddUserGroupMembersRequest(
  asAdmin: json['as_admin'] as bool?,
  memberIds: (json['member_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  teamId: json['team_id'] as String?,
);

Map<String, dynamic> _$AddUserGroupMembersRequestToJson(
  AddUserGroupMembersRequest instance,
) => <String, dynamic>{
  'as_admin': instance.asAdmin,
  'member_ids': instance.memberIds,
  'team_id': instance.teamId,
};
