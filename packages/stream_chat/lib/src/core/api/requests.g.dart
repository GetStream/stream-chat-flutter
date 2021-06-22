// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortOption<T> _$SortOptionFromJson<T>(Map<String, dynamic> json) {
  return SortOption<T>(
    json['field'] as String,
    direction: json['direction'] as int,
  );
}

Map<String, dynamic> _$SortOptionToJson<T>(SortOption<T> instance) =>
    <String, dynamic>{
      'field': instance.field,
      'direction': instance.direction,
    };

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) {
  return PaginationParams(
    limit: json['limit'] as int,
    offset: json['offset'] as int,
    greaterThan: json['id_gt'] as String?,
    greaterThanOrEqual: json['id_gte'] as String?,
    lessThan: json['id_lt'] as String?,
    lessThanOrEqual: json['id_lte'] as String?,
  );
}

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) {
  final val = <String, dynamic>{
    'limit': instance.limit,
    'offset': instance.offset,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id_gt', instance.greaterThan);
  writeNotNull('id_gte', instance.greaterThanOrEqual);
  writeNotNull('id_lt', instance.lessThan);
  writeNotNull('id_lte', instance.lessThanOrEqual);
  return val;
}
