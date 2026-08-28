// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_banned_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryBannedUsersResponse _$QueryBannedUsersResponseFromJson(
  Map<String, dynamic> json,
) => QueryBannedUsersResponse(
  bans: (json['bans'] as List<dynamic>)
      .map((e) => BanResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$QueryBannedUsersResponseToJson(
  QueryBannedUsersResponse instance,
) => <String, dynamic>{
  'bans': instance.bans.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
};
