// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_appeals_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryAppealsRequest _$QueryAppealsRequestFromJson(Map<String, dynamic> json) =>
    QueryAppealsRequest(
      filter: json['filter'] as Map<String, dynamic>?,
      limit: (json['limit'] as num?)?.toInt(),
      next: json['next'] as String?,
      prev: json['prev'] as String?,
      sort: (json['sort'] as List<dynamic>?)
          ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QueryAppealsRequestToJson(
  QueryAppealsRequest instance,
) => <String, dynamic>{
  'filter': instance.filter,
  'limit': instance.limit,
  'next': instance.next,
  'prev': instance.prev,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
};
