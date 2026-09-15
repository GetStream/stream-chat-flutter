// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_future_channel_bans_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryFutureChannelBansPayload _$QueryFutureChannelBansPayloadFromJson(
  Map<String, dynamic> json,
) => QueryFutureChannelBansPayload(
  excludeExpiredBans: json['exclude_expired_bans'] as bool?,
  includeTotal: json['include_total'] as bool?,
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
  targetUserId: json['target_user_id'] as String?,
);

Map<String, dynamic> _$QueryFutureChannelBansPayloadToJson(
  QueryFutureChannelBansPayload instance,
) => <String, dynamic>{
  'exclude_expired_bans': instance.excludeExpiredBans,
  'include_total': instance.includeTotal,
  'limit': instance.limit,
  'offset': instance.offset,
  'target_user_id': instance.targetUserId,
};
