// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_user_request_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteUserRequestPayload _$DeleteUserRequestPayloadFromJson(
  Map<String, dynamic> json,
) => DeleteUserRequestPayload(
  deleteConversationChannels: json['delete_conversation_channels'] as bool?,
  deleteFeedsContent: json['delete_feeds_content'] as bool?,
  entityId: json['entity_id'] as String?,
  entityType: json['entity_type'] as String?,
  hardDelete: json['hard_delete'] as bool?,
  markMessagesDeleted: json['mark_messages_deleted'] as bool?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$DeleteUserRequestPayloadToJson(
  DeleteUserRequestPayload instance,
) => <String, dynamic>{
  'delete_conversation_channels': instance.deleteConversationChannels,
  'delete_feeds_content': instance.deleteFeedsContent,
  'entity_id': instance.entityId,
  'entity_type': instance.entityType,
  'hard_delete': instance.hardDelete,
  'mark_messages_deleted': instance.markMessagesDeleted,
  'reason': instance.reason,
};
