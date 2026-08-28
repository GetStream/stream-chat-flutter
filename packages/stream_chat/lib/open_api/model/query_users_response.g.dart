// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryUsersResponse _$QueryUsersResponseFromJson(Map<String, dynamic> json) =>
    QueryUsersResponse(
      duration: json['duration'] as String,
      users: (json['users'] as List<dynamic>)
          .map((e) => FullUserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QueryUsersResponseToJson(QueryUsersResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'users': instance.users.map((e) => e.toJson()).toList(),
    };
