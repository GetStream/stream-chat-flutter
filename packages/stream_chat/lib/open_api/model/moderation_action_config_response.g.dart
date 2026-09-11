// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_action_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationActionConfigResponse _$ModerationActionConfigResponseFromJson(
  Map<String, dynamic> json,
) => ModerationActionConfigResponse(
  action: json['action'] as String,
  custom: json['custom'] as Map<String, dynamic>?,
  description: json['description'] as String,
  entityType: json['entity_type'] as String,
  icon: json['icon'] as String,
  id: json['id'] as String?,
  order: (json['order'] as num).toInt(),
  queueType: json['queue_type'] as String?,
);

Map<String, dynamic> _$ModerationActionConfigResponseToJson(
  ModerationActionConfigResponse instance,
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
