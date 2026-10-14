// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_user_groups_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListUserGroupsResponse _$ListUserGroupsResponseFromJson(
  Map<String, dynamic> json,
) => ListUserGroupsResponse(
  duration: json['duration'] as String,
  userGroups: (json['user_groups'] as List<dynamic>)
      .map((e) => UserGroupResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListUserGroupsResponseToJson(
  ListUserGroupsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'user_groups': instance.userGroups.map((e) => e.toJson()).toList(),
};
