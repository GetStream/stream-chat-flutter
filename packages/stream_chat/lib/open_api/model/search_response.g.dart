// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResponse _$SearchResponseFromJson(Map<String, dynamic> json) => SearchResponse(
  duration: json['duration'] as String,
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>).map((e) => SearchResult.fromJson(e as Map<String, dynamic>)).toList(),
  resultsWarning: json['results_warning'] == null
      ? null
      : SearchWarning.fromJson(
          json['results_warning'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SearchResponseToJson(SearchResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results.map((e) => e.toJson()).toList(),
  'results_warning': instance.resultsWarning?.toJson(),
};
