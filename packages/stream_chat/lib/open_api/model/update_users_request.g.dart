// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_users_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUsersRequest _$UpdateUsersRequestFromJson(Map<String, dynamic> json) =>
    UpdateUsersRequest(
      users: (json['users'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, UserRequest.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$UpdateUsersRequestToJson(UpdateUsersRequest instance) =>
    <String, dynamic>{
      'users': instance.users.map((k, e) => MapEntry(k, e.toJson())),
    };
