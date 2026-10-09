// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_queue_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationQueueResponse _$ModerationQueueResponseFromJson(
  Map<String, dynamic> json,
) => ModerationQueueResponse(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] as String,
  description: json['description'] as String,
  filters: json['filters'] as Map<String, dynamic>,
  id: json['id'] as String,
  itemCount: (json['item_count'] as num).toInt(),
  name: json['name'] as String,
  sort: (json['sort'] as List<dynamic>).map((e) => e as Map<String, dynamic>).toList(),
  type: json['type'] as String,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$ModerationQueueResponseToJson(
  ModerationQueueResponse instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy,
  'description': instance.description,
  'filters': instance.filters,
  'id': instance.id,
  'item_count': instance.itemCount,
  'name': instance.name,
  'sort': instance.sort,
  'type': instance.type,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
};
