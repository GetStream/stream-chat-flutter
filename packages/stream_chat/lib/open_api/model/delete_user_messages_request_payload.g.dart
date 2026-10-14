// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_user_messages_request_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteUserMessagesRequestPayload _$DeleteUserMessagesRequestPayloadFromJson(
  Map<String, dynamic> json,
) => DeleteUserMessagesRequestPayload(
  channelCid: json['channel_cid'] as String?,
  deleteMessages: DeleteUserMessagesRequestPayloadDeleteMessages.fromJson(
    json['delete_messages'] as String,
  ),
  deleteReactions: json['delete_reactions'] as bool?,
  entityId: json['entity_id'] as String?,
  entityType: json['entity_type'] as String?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$DeleteUserMessagesRequestPayloadToJson(
  DeleteUserMessagesRequestPayload instance,
) => <String, dynamic>{
  'channel_cid': instance.channelCid,
  'delete_messages': instance.deleteMessages.toJson(),
  'delete_reactions': instance.deleteReactions,
  'entity_id': instance.entityId,
  'entity_type': instance.entityType,
  'reason': instance.reason,
};
