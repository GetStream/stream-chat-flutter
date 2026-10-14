// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_mark_reviewed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationMarkReviewedEvent _$ModerationMarkReviewedEventFromJson(
  Map<String, dynamic> json,
) => ModerationMarkReviewedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  item: ReviewQueueItemResponse.fromJson(json['item'] as Map<String, dynamic>),
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ModerationMarkReviewedEventToJson(
  ModerationMarkReviewedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'item': instance.item.toJson(),
  'message': instance.message?.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
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
