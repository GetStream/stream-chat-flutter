// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_custom_action_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationCustomActionEvent _$ModerationCustomActionEventFromJson(
  Map<String, dynamic> json,
) => ModerationCustomActionEvent(
  actionId: json['action_id'] as String,
  actionOptions: json['action_options'] as Map<String, dynamic>?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reviewQueueItem: ReviewQueueItemResponse.fromJson(
    json['review_queue_item'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ModerationCustomActionEventToJson(
  ModerationCustomActionEvent instance,
) => <String, dynamic>{
  'action_id': instance.actionId,
  'action_options': instance.actionOptions,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message': instance.message?.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'review_queue_item': instance.reviewQueueItem.toJson(),
  'type': instance.type,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
