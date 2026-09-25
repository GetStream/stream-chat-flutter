// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_members_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryMembersPayload _$QueryMembersPayloadFromJson(Map<String, dynamic> json) => QueryMembersPayload(
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
  filterConditions: json['filter_conditions'] as Map<String, dynamic>?,
  id: json['id'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => ChannelMemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  offset: (json['offset'] as num?)?.toInt(),
  sort: (json['sort'] as List<dynamic>?)?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>)).toList(),
  type: json['type'] as String,
  userIdGt: json['user_id_gt'] as String?,
  userIdGte: json['user_id_gte'] as String?,
  userIdLt: json['user_id_lt'] as String?,
  userIdLte: json['user_id_lte'] as String?,
);

Map<String, dynamic> _$QueryMembersPayloadToJson(
  QueryMembersPayload instance,
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
  'filter_conditions': instance.filterConditions,
  'id': instance.id,
  'limit': instance.limit,
  'members': instance.members?.map((e) => e.toJson()).toList(),
  'offset': instance.offset,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
  'type': instance.type,
  'user_id_gt': instance.userIdGt,
  'user_id_gte': instance.userIdGte,
  'user_id_lt': instance.userIdLt,
  'user_id_lte': instance.userIdLte,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
