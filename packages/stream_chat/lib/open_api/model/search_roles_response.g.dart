// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_roles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRolesResponse _$SearchRolesResponseFromJson(Map<String, dynamic> json) =>
    SearchRolesResponse(
      duration: json['duration'] as String,
      roles: (json['roles'] as List<dynamic>)
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchRolesResponseToJson(
  SearchRolesResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'roles': instance.roles.map((e) => e.toJson()).toList(),
};
