// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_updated_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftUpdatedEvent _$DraftUpdatedEventFromJson(Map<String, dynamic> json) =>
    DraftUpdatedEvent(
      cid: json['cid'] as String?,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      draft: json['draft'] == null
          ? null
          : DraftResponse.fromJson(json['draft'] as Map<String, dynamic>),
      parentId: json['parent_id'] as String?,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$DraftUpdatedEventToJson(DraftUpdatedEvent instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'draft': instance.draft?.toJson(),
      'parent_id': instance.parentId,
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
