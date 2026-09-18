// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  message: json['message'] == null ? null : SearchResultMessage.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) => <String, dynamic>{
  'message': instance.message?.toJson(),
};
