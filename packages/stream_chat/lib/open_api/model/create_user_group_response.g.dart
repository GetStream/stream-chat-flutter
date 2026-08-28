// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserGroupResponse _$CreateUserGroupResponseFromJson(
  Map<String, dynamic> json,
) => CreateUserGroupResponse(
  duration: json['duration'] as String,
  userGroup: json['user_group'] == null
      ? null
      : UserGroupResponse.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateUserGroupResponseToJson(
  CreateUserGroupResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'user_group': instance.userGroup?.toJson(),
};
