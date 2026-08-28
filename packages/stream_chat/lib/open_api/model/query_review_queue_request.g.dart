// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_review_queue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryReviewQueueRequest _$QueryReviewQueueRequestFromJson(
  Map<String, dynamic> json,
) => QueryReviewQueueRequest(
  excludeDefaultActionConfig: json['exclude_default_action_config'] as bool?,
  filter: json['filter'] as Map<String, dynamic>?,
  limit: (json['limit'] as num?)?.toInt(),
  lockCount: (json['lock_count'] as num?)?.toInt(),
  lockDuration: (json['lock_duration'] as num?)?.toInt(),
  lockItems: json['lock_items'] as bool?,
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  sort: (json['sort'] as List<dynamic>?)
      ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  statsOnly: json['stats_only'] as bool?,
);

Map<String, dynamic> _$QueryReviewQueueRequestToJson(
  QueryReviewQueueRequest instance,
) => <String, dynamic>{
  'exclude_default_action_config': instance.excludeDefaultActionConfig,
  'filter': instance.filter,
  'limit': instance.limit,
  'lock_count': instance.lockCount,
  'lock_duration': instance.lockDuration,
  'lock_items': instance.lockItems,
  'next': instance.next,
  'prev': instance.prev,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
  'stats_only': instance.statsOnly,
};
