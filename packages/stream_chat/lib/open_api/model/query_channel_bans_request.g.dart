// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_channel_bans_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryChannelBansRequest _$QueryChannelBansRequestFromJson(
  Map<String, dynamic> json,
) => QueryChannelBansRequest(
  excludeExpiredBans: json['exclude_expired_bans'] as bool?,
  filterConditions: json['filter_conditions'] as Map<String, dynamic>?,
  includeTotal: json['include_total'] as bool?,
  limit: (json['limit'] as num?)?.toInt(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$QueryChannelBansRequestToJson(
  QueryChannelBansRequest instance,
) => <String, dynamic>{
  'exclude_expired_bans': instance.excludeExpiredBans,
  'filter_conditions': instance.filterConditions,
  'include_total': instance.includeTotal,
  'limit': instance.limit,
  'next': instance.next,
  'prev': instance.prev,
};
