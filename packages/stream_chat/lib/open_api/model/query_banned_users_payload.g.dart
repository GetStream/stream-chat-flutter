// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_banned_users_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryBannedUsersPayload _$QueryBannedUsersPayloadFromJson(
  Map<String, dynamic> json,
) => QueryBannedUsersPayload(
  createdAtAfter: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at_after'],
    const StreamDateTimeConverter().fromJson,
  ),
  createdAtAfterOrEqual: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at_after_or_equal'],
    const StreamDateTimeConverter().fromJson,
  ),
  createdAtBefore: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at_before'],
    const StreamDateTimeConverter().fromJson,
  ),
  createdAtBeforeOrEqual: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at_before_or_equal'],
    const StreamDateTimeConverter().fromJson,
  ),
  excludeExpiredBans: json['exclude_expired_bans'] as bool?,
  filterConditions: json['filter_conditions'] as Map<String, dynamic>,
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
  sort: (json['sort'] as List<dynamic>?)?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$QueryBannedUsersPayloadToJson(
  QueryBannedUsersPayload instance,
) => <String, dynamic>{
  'created_at_after': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAtAfter,
    const StreamDateTimeConverter().toJson,
  ),
  'created_at_after_or_equal': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAtAfterOrEqual,
    const StreamDateTimeConverter().toJson,
  ),
  'created_at_before': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAtBefore,
    const StreamDateTimeConverter().toJson,
  ),
  'created_at_before_or_equal': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAtBeforeOrEqual,
    const StreamDateTimeConverter().toJson,
  ),
  'exclude_expired_bans': instance.excludeExpiredBans,
  'filter_conditions': instance.filterConditions,
  'limit': instance.limit,
  'offset': instance.offset,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
