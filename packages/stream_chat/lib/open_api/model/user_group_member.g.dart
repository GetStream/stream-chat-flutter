// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGroupMember _$UserGroupMemberFromJson(Map<String, dynamic> json) => UserGroupMember(
  appPk: (json['app_pk'] as num).toInt(),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  groupId: json['group_id'] as String,
  isAdmin: json['is_admin'] as bool,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$UserGroupMemberToJson(UserGroupMember instance) => <String, dynamic>{
  'app_pk': instance.appPk,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'group_id': instance.groupId,
  'is_admin': instance.isAdmin,
  'user_id': instance.userId,
};
