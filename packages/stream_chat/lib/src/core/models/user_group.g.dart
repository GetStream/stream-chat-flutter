// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGroup _$UserGroupFromJson(Map<String, dynamic> json) => UserGroup(
  createdAt: DateTime.parse(json['created_at'] as String),
  createdBy: json['created_by'] as String?,
  description: json['description'] as String?,
  id: json['id'] as String,
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => UserGroupMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  name: json['name'] as String,
  teamId: json['team_id'] as String?,
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserGroupToJson(UserGroup instance) => <String, dynamic>{
  'created_at': instance.createdAt.toIso8601String(),
  'created_by': ?instance.createdBy,
  'description': ?instance.description,
  'id': instance.id,
  'members': ?instance.members?.map((e) => e.toJson()).toList(),
  'name': instance.name,
  'team_id': ?instance.teamId,
  'updated_at': instance.updatedAt.toIso8601String(),
};
