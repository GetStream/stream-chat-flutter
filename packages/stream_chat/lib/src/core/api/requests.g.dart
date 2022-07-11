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
      offset: json['offset'] as int?,
      next: json['next'] as String?,
      idAround: json['id_around'] as String?,
      greaterThan: json['id_gt'] as String?,
      greaterThanOrEqual: json['id_gte'] as String?,
      lessThan: json['id_lt'] as String?,
      lessThanOrEqual: json['id_lte'] as String?,
      createdAtAfterOrEqual: json['created_at_after_or_equal'] == null
          ? null
          : DateTime.parse(json['created_at_after_or_equal'] as String),
      createdAtAfter: json['created_at_after'] == null
          ? null
          : DateTime.parse(json['created_at_after'] as String),
      createdAtBeforeOrEqual: json['created_at_before_or_equal'] == null
          ? null
          : DateTime.parse(json['created_at_before_or_equal'] as String),
      createdAtBefore: json['created_at_before'] == null
          ? null
          : DateTime.parse(json['created_at_before'] as String),
      createdAtAround: json['created_at_around'] == null
          ? null
          : DateTime.parse(json['created_at_around'] as String),
    );

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) {
  final val = <String, dynamic>{
    'limit': instance.limit,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('offset', instance.offset);
  writeNotNull('next', instance.next);
  writeNotNull('id_around', instance.idAround);
  writeNotNull('id_gt', instance.greaterThan);
  writeNotNull('id_gte', instance.greaterThanOrEqual);
  writeNotNull('id_lt', instance.lessThan);
  writeNotNull('id_lte', instance.lessThanOrEqual);
  writeNotNull('created_at_after_or_equal',
      instance.createdAtAfterOrEqual?.toIso8601String());
  writeNotNull('created_at_after', instance.createdAtAfter?.toIso8601String());
  writeNotNull('created_at_before_or_equal',
      instance.createdAtBeforeOrEqual?.toIso8601String());
  writeNotNull(
      'created_at_before', instance.createdAtBefore?.toIso8601String());
  writeNotNull(
      'created_at_around', instance.createdAtAround?.toIso8601String());
  return val;
}

Map<String, dynamic> _$PartialUpdateUserRequestToJson(
        PartialUpdateUserRequest instance) =>
    <String, dynamic>{
      'stringify': instance.stringify,
      'hash_code': instance.hashCode,
      'id': instance.id,
      'set': instance.set,
      'unset': instance.unset,
      'props': instance.props,
    };
