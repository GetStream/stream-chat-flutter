// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUserGroupResponse _$GetUserGroupResponseFromJson(
  Map<String, dynamic> json,
) => GetUserGroupResponse(
  duration: json['duration'] as String,
  userGroup: json['user_group'] == null
      ? null
      : UserGroupResponse.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetUserGroupResponseToJson(
  GetUserGroupResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'user_group': instance.userGroup?.toJson(),
};
