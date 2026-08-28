// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_threads_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryThreadsRequest _$QueryThreadsRequestFromJson(Map<String, dynamic> json) =>
    QueryThreadsRequest(
      filter: json['filter'] as Map<String, dynamic>?,
      limit: (json['limit'] as num?)?.toInt(),
      memberLimit: (json['member_limit'] as num?)?.toInt(),
      next: json['next'] as String?,
      participantLimit: (json['participant_limit'] as num?)?.toInt(),
      prev: json['prev'] as String?,
      replyLimit: (json['reply_limit'] as num?)?.toInt(),
      sort: (json['sort'] as List<dynamic>?)
          ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      watch: json['watch'] as bool?,
    );

Map<String, dynamic> _$QueryThreadsRequestToJson(
  QueryThreadsRequest instance,
) => <String, dynamic>{
  'filter': instance.filter,
  'limit': instance.limit,
  'member_limit': instance.memberLimit,
  'next': instance.next,
  'participant_limit': instance.participantLimit,
  'prev': instance.prev,
  'reply_limit': instance.replyLimit,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
  'watch': instance.watch,
};
