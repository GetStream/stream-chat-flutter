// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flag_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlagRequest _$FlagRequestFromJson(Map<String, dynamic> json) => FlagRequest(
  custom: json['custom'] as Map<String, dynamic>?,
  entityCreatorId: json['entity_creator_id'] as String?,
  entityId: json['entity_id'] as String,
  entityType: json['entity_type'] as String,
  moderationPayload: json['moderation_payload'] == null
      ? null
      : ModerationPayload.fromJson(
          json['moderation_payload'] as Map<String, dynamic>,
        ),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$FlagRequestToJson(FlagRequest instance) =>
    <String, dynamic>{
      'custom': instance.custom,
      'entity_creator_id': instance.entityCreatorId,
      'entity_id': instance.entityId,
      'entity_type': instance.entityType,
      'moderation_payload': instance.moderationPayload?.toJson(),
      'reason': instance.reason,
    };
