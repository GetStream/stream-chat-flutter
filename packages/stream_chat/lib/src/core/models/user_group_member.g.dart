// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGroupMember _$UserGroupMemberFromJson(Map<String, dynamic> json) => UserGroupMember(
  createdAt: DateTime.parse(json['created_at'] as String),
  groupId: json['group_id'] as String,
  isAdmin: json['is_admin'] as bool,
  userId: json['user_id'] as String,
);
