// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) => PaginationParams(
  idGt: (json['id_gt'] as num?)?.toInt(),
  idGte: (json['id_gte'] as num?)?.toInt(),
  idLt: (json['id_lt'] as num?)?.toInt(),
  idLte: (json['id_lte'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) => <String, dynamic>{
  'id_gt': instance.idGt,
  'id_gte': instance.idGte,
  'id_lt': instance.idLt,
  'id_lte': instance.idLte,
  'limit': instance.limit,
  'offset': instance.offset,
};
