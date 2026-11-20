// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_users_partial_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUsersPartialRequest _$UpdateUsersPartialRequestFromJson(
  Map<String, dynamic> json,
) => UpdateUsersPartialRequest(
  users: (json['users'] as List<dynamic>)
      .map((e) => UpdateUserPartialRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpdateUsersPartialRequestToJson(
  UpdateUsersPartialRequest instance,
) => <String, dynamic>{'users': instance.users.map((e) => e.toJson()).toList()};
