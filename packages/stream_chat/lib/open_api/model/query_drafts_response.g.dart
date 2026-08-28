// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_drafts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryDraftsResponse _$QueryDraftsResponseFromJson(Map<String, dynamic> json) =>
    QueryDraftsResponse(
      drafts: (json['drafts'] as List<dynamic>)
          .map((e) => DraftResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      duration: json['duration'] as String,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );

Map<String, dynamic> _$QueryDraftsResponseToJson(
  QueryDraftsResponse instance,
) => <String, dynamic>{
  'drafts': instance.drafts.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
  'next': instance.next,
  'prev': instance.prev,
};
