// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortOption<T> _$SortOptionFromJson<T extends ComparableFieldProvider>(
        Map<String, dynamic> json) =>
    SortOption<T>(
      json['field'] as String,
      direction: (json['direction'] as num?)?.toInt() ?? SortOption.DESC,
    );

Map<String, dynamic> _$SortOptionToJson<T extends ComparableFieldProvider>(
        SortOption<T> instance) =>
    <String, dynamic>{
      'field': instance.field,
      'direction': instance.direction,
    };
