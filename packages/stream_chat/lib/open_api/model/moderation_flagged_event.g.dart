// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_flagged_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationFlaggedEvent _$ModerationFlaggedEventFromJson(
  Map<String, dynamic> json,
) => ModerationFlaggedEvent(
  contentType: json['content_type'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  objectId: json['object_id'] as String,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ModerationFlaggedEventToJson(
  ModerationFlaggedEvent instance,
) => <String, dynamic>{
  'content_type': instance.contentType,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'object_id': instance.objectId,
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
