// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_group_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserGroupResponse _$UpdateUserGroupResponseFromJson(
  Map<String, dynamic> json,
) => UpdateUserGroupResponse(
  duration: json['duration'] as String,
  userGroup: json['user_group'] == null
      ? null
      : UserGroupResponse.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateUserGroupResponseToJson(
  UpdateUserGroupResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'user_group': instance.userGroup?.toJson(),
};
