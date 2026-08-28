// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_blocked_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBlockedUsersResponse _$GetBlockedUsersResponseFromJson(
  Map<String, dynamic> json,
) => GetBlockedUsersResponse(
  blocks: (json['blocks'] as List<dynamic>)
      .map((e) => BlockedUserResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$GetBlockedUsersResponseToJson(
  GetBlockedUsersResponse instance,
) => <String, dynamic>{
  'blocks': instance.blocks.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
};
