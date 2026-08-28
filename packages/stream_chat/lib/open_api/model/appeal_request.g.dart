// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appeal_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppealRequest _$AppealRequestFromJson(Map<String, dynamic> json) =>
    AppealRequest(
      appealReason: json['appeal_reason'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      entityId: json['entity_id'] as String,
      entityType: json['entity_type'] as String,
      reviewQueueItemId: json['review_queue_item_id'] as String?,
    );

Map<String, dynamic> _$AppealRequestToJson(AppealRequest instance) =>
    <String, dynamic>{
      'appeal_reason': instance.appealReason,
      'attachments': instance.attachments,
      'entity_id': instance.entityId,
      'entity_type': instance.entityType,
      'review_queue_item_id': instance.reviewQueueItemId,
    };
