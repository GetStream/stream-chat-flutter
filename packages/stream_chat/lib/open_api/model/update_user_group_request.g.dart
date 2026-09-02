// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_group_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserGroupRequest _$UpdateUserGroupRequestFromJson(
  Map<String, dynamic> json,
) => UpdateUserGroupRequest(
  description: json['description'] as String?,
  name: json['name'] as String?,
  teamId: json['team_id'] as String?,
);

Map<String, dynamic> _$UpdateUserGroupRequestToJson(
  UpdateUserGroupRequest instance,
) => <String, dynamic>{
  'description': instance.description,
  'name': instance.name,
  'team_id': instance.teamId,
};
