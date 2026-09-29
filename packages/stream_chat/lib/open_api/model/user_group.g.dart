// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGroup _$UserGroupFromJson(Map<String, dynamic> json) => UserGroup(
  appPk: (json['app_pk'] as num).toInt(),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] as String?,
  description: json['description'] as String?,
  id: json['id'] as String,
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => UserGroupMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  name: json['name'] as String,
  teamId: json['team_id'] as String?,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$UserGroupToJson(UserGroup instance) => <String, dynamic>{
  'app_pk': instance.appPk,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy,
  'description': instance.description,
  'id': instance.id,
  'members': instance.members?.map((e) => e.toJson()).toList(),
  'name': instance.name,
  'team_id': instance.teamId,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
};
