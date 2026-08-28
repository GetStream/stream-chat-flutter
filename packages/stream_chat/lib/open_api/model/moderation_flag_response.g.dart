// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_flag_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationFlagResponse _$ModerationFlagResponseFromJson(
  Map<String, dynamic> json,
) => ModerationFlagResponse(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>?,
  entityCreatorId: json['entity_creator_id'] as String?,
  entityId: json['entity_id'] as String,
  entityType: json['entity_type'] as String,
  labels: (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
  moderationPayload: json['moderation_payload'] == null
      ? null
      : ModerationPayloadResponse.fromJson(
          json['moderation_payload'] as Map<String, dynamic>,
        ),
  reason: json['reason'] as String?,
  result: (json['result'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  reviewQueueItem: json['review_queue_item'] == null
      ? null
      : ReviewQueueItemResponse.fromJson(
          json['review_queue_item'] as Map<String, dynamic>,
        ),
  reviewQueueItemId: json['review_queue_item_id'] as String?,
  type: json['type'] as String,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: json['user'] == null
      ? null
      : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ModerationFlagResponseToJson(
  ModerationFlagResponse instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'entity_creator_id': instance.entityCreatorId,
  'entity_id': instance.entityId,
  'entity_type': instance.entityType,
  'labels': instance.labels,
  'moderation_payload': instance.moderationPayload?.toJson(),
  'reason': instance.reason,
  'result': instance.result,
  'review_queue_item': instance.reviewQueueItem?.toJson(),
  'review_queue_item_id': instance.reviewQueueItemId,
  'type': instance.type,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user?.toJson(),
  'user_id': instance.userId,
};
