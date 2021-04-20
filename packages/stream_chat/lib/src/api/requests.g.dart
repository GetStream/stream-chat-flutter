// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$SortOptionToJson<T>(SortOption<T> instance) =>
    <String, dynamic>{
      'field': instance.field,
      'direction': instance.direction,
    };

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
