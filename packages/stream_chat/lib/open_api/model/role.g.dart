// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as bool,
  name: json['name'] as String,
  scopes: (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'name': instance.name,
  'scopes': instance.scopes,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
};
