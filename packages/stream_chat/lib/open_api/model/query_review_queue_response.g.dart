// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_review_queue_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryReviewQueueResponse _$QueryReviewQueueResponseFromJson(
  Map<String, dynamic> json,
) => QueryReviewQueueResponse(
  actionConfig: (json['action_config'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map(
            (e) => ModerationActionConfigResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    ),
  ),
  defaultActionConfig: (json['default_action_config'] as Map<String, dynamic>?)
      ?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map(
                (e) => ModerationActionConfigResponse.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        ),
      ),
  duration: json['duration'] as String,
  filterConfig: json['filter_config'] == null
      ? null
      : FilterConfigResponse.fromJson(
          json['filter_config'] as Map<String, dynamic>,
        ),
  items: (json['items'] as List<dynamic>)
      .map((e) => ReviewQueueItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  stats: json['stats'] as Map<String, dynamic>,
);

Map<String, dynamic> _$QueryReviewQueueResponseToJson(
  QueryReviewQueueResponse instance,
) => <String, dynamic>{
  'action_config': instance.actionConfig.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'default_action_config': instance.defaultActionConfig?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'duration': instance.duration,
  'filter_config': instance.filterConfig?.toJson(),
  'items': instance.items.map((e) => e.toJson()).toList(),
  'next': instance.next,
  'prev': instance.prev,
  'stats': instance.stats,
};
