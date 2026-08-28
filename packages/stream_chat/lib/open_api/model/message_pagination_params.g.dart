// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagePaginationParams _$MessagePaginationParamsFromJson(
  Map<String, dynamic> json,
) => MessagePaginationParams(
  createdAtAfter: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at_after'],
    const StreamDateTimeConverter().fromJson,
  ),
  createdAtAfterOrEqual: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at_after_or_equal'],
    const StreamDateTimeConverter().fromJson,
  ),
  createdAtAround: _$JsonConverterFromJson<Object, DateTime>(
    json['created_at_around'],
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
  idAround: json['id_around'] as String?,
  idGt: json['id_gt'] as String?,
  idGte: json['id_gte'] as String?,
  idLt: json['id_lt'] as String?,
  idLte: json['id_lte'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
);

Map<String, dynamic> _$MessagePaginationParamsToJson(
  MessagePaginationParams instance,
) => <String, dynamic>{
  'created_at_after': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAtAfter,
    const StreamDateTimeConverter().toJson,
  ),
  'created_at_after_or_equal': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAtAfterOrEqual,
    const StreamDateTimeConverter().toJson,
  ),
  'created_at_around': _$JsonConverterToJson<Object, DateTime>(
    instance.createdAtAround,
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
  'id_around': instance.idAround,
  'id_gt': instance.idGt,
  'id_gte': instance.idGte,
  'id_lt': instance.idLt,
  'id_lte': instance.idLte,
  'limit': instance.limit,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
