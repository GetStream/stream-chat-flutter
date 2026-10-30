// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_fork_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelForkResponse _$ChannelForkResponseFromJson(Map<String, dynamic> json) => ChannelForkResponse(
  channelCid: json['channel_cid'] as String,
  copiedMessageCount: (json['copied_message_count'] as num).toInt(),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  failedReason: json['failed_reason'] as String?,
  messageIdMap: Map<String, String>.from(json['message_id_map'] as Map),
  oldestSourceMessageId: json['oldest_source_message_id'] as String?,
  sourceChannelCid: json['source_channel_cid'] as String,
  sourceMessageId: json['source_message_id'] as String,
  status: json['status'] as String,
  taskId: json['task_id'] as String?,
  truncated: json['truncated'] as bool?,
);

Map<String, dynamic> _$ChannelForkResponseToJson(
  ChannelForkResponse instance,
) => <String, dynamic>{
  'channel_cid': instance.channelCid,
  'copied_message_count': instance.copiedMessageCount,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'failed_reason': instance.failedReason,
  'message_id_map': instance.messageIdMap,
  'oldest_source_message_id': instance.oldestSourceMessageId,
  'source_channel_cid': instance.sourceChannelCid,
  'source_message_id': instance.sourceMessageId,
  'status': instance.status,
  'task_id': instance.taskId,
  'truncated': instance.truncated,
};
