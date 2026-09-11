// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_banned_users_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryBannedUsersPayload _$QueryBannedUsersPayloadFromJson(
  Map<String, dynamic> json,
) => QueryBannedUsersPayload(
  excludeExpiredBans: json['exclude_expired_bans'] as bool?,
  filterConditions: json['filter_conditions'] as Map<String, dynamic>,
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
  sort: (json['sort'] as List<dynamic>?)?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$QueryBannedUsersPayloadToJson(
  QueryBannedUsersPayload instance,
) => <String, dynamic>{
  'exclude_expired_bans': instance.excludeExpiredBans,
  'filter_conditions': instance.filterConditions,
  'limit': instance.limit,
  'offset': instance.offset,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
};
