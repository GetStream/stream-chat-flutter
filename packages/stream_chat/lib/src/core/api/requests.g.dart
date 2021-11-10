// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortOption<T> _$SortOptionFromJson<T>(Map<String, dynamic> json) =>
    SortOption<T>(
      json['field'] as String,
      direction: json['direction'] as int? ?? SortOption.DESC,
    );

Map<String, dynamic> _$SortOptionToJson<T>(SortOption<T> instance) =>
    <String, dynamic>{
      'field': instance.field,
      'direction': instance.direction,
    };

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) =>
    PaginationParams(
      limit: json['limit'] as int? ?? 10,
      before: json['before'] as int? ?? 10,
      after: json['after'] as int? ?? 10,
      offset: json['offset'] as int?,
      next: json['next'] as String?,
      aroundId: json['around_id'] as String?,
      greaterThan: json['id_gt'] as String?,
      greaterThanOrEqual: json['id_gte'] as String?,
      lessThan: json['id_lt'] as String?,
      lessThanOrEqual: json['id_lte'] as String?,
    );

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) {
  final val = <String, dynamic>{
    'limit': instance.limit,
    'before': instance.before,
    'after': instance.after,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('offset', instance.offset);
  writeNotNull('next', instance.next);
  writeNotNull('around_id', instance.aroundId);
  writeNotNull('id_gt', instance.greaterThan);
  writeNotNull('id_gte', instance.greaterThanOrEqual);
  writeNotNull('id_lt', instance.lessThan);
  writeNotNull('id_lte', instance.lessThanOrEqual);
  return val;
}
