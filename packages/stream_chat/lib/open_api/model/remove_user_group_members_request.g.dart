// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_user_group_members_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveUserGroupMembersRequest _$RemoveUserGroupMembersRequestFromJson(
  Map<String, dynamic> json,
) => RemoveUserGroupMembersRequest(
  memberIds: (json['member_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  teamId: json['team_id'] as String?,
);

Map<String, dynamic> _$RemoveUserGroupMembersRequestToJson(
  RemoveUserGroupMembersRequest instance,
) => <String, dynamic>{
  'member_ids': instance.memberIds,
  'team_id': instance.teamId,
};
