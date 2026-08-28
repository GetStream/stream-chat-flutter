// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_group_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserGroupRequest _$CreateUserGroupRequestFromJson(
  Map<String, dynamic> json,
) => CreateUserGroupRequest(
  description: json['description'] as String?,
  id: json['id'] as String?,
  memberIds: (json['member_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  name: json['name'] as String,
  teamId: json['team_id'] as String?,
);

Map<String, dynamic> _$CreateUserGroupRequestToJson(
  CreateUserGroupRequest instance,
) => <String, dynamic>{
  'description': instance.description,
  'id': instance.id,
  'member_ids': instance.memberIds,
  'name': instance.name,
  'team_id': instance.teamId,
};
