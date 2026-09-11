// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_user_groups_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUserGroupsResponse _$SearchUserGroupsResponseFromJson(
  Map<String, dynamic> json,
) => SearchUserGroupsResponse(
  duration: json['duration'] as String,
  userGroups: (json['user_groups'] as List<dynamic>)
      .map((e) => UserGroupResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SearchUserGroupsResponseToJson(
  SearchUserGroupsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'user_groups': instance.userGroups.map((e) => e.toJson()).toList(),
};
