// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_comment_request_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteCommentRequestPayload _$DeleteCommentRequestPayloadFromJson(
  Map<String, dynamic> json,
) => DeleteCommentRequestPayload(
  entityId: json['entity_id'] as String?,
  entityType: json['entity_type'] as String?,
  hardDelete: json['hard_delete'] as bool?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$DeleteCommentRequestPayloadToJson(
  DeleteCommentRequestPayload instance,
) => <String, dynamic>{
  'entity_id': instance.entityId,
  'entity_type': instance.entityType,
  'hard_delete': instance.hardDelete,
  'reason': instance.reason,
};
