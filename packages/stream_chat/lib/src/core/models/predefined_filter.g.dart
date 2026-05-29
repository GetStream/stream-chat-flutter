// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predefined_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredefinedFilter _$PredefinedFilterFromJson(Map<String, dynamic> json) =>
    PredefinedFilter(
      name: json['name'] as String,
      filter: json['filter'] as Map<String, dynamic>,
      sort: (json['sort'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
