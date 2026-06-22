// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
  createdAt: DateTime.parse(json['created_at'] as String),
  custom: json['custom'] as bool,
  name: json['name'] as String,
  scopes: (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);
