// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parsed_predefined_filter_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParsedPredefinedFilterResponse _$ParsedPredefinedFilterResponseFromJson(
  Map<String, dynamic> json,
) => ParsedPredefinedFilterResponse(
  filter: json['filter'] as Map<String, dynamic>,
  name: json['name'] as String,
  sort: (json['sort'] as List<dynamic>?)?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$ParsedPredefinedFilterResponseToJson(
  ParsedPredefinedFilterResponse instance,
) => <String, dynamic>{
  'filter': instance.filter,
  'name': instance.name,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
};
