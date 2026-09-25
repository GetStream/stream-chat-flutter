// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_action_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertActionConfigRequest _$UpsertActionConfigRequestFromJson(
  Map<String, dynamic> json,
) => UpsertActionConfigRequest(
  action: json['action'] as String,
  custom: json['custom'] as Map<String, dynamic>?,
  description: json['description'] as String?,
  entityType: json['entity_type'] as String,
  icon: json['icon'] as String?,
  id: json['id'] as String?,
  order: (json['order'] as num).toInt(),
  queueType: json['queue_type'] as String?,
);

Map<String, dynamic> _$UpsertActionConfigRequestToJson(
  UpsertActionConfigRequest instance,
) => <String, dynamic>{
  'action': instance.action,
  'custom': instance.custom,
  'description': instance.description,
  'entity_type': instance.entityType,
  'icon': instance.icon,
  'id': instance.id,
  'order': instance.order,
  'queue_type': instance.queueType,
};
