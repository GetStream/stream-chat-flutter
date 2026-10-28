// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_fork_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelForkSummary _$ChannelForkSummaryFromJson(Map<String, dynamic> json) => ChannelForkSummary(
  channelCid: json['channel_cid'] as String,
  copiedMessageCount: (json['copied_message_count'] as num).toInt(),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  sourceChannelCid: json['source_channel_cid'] as String,
  sourceMessageId: json['source_message_id'] as String,
  status: json['status'] as String,
  taskId: json['task_id'] as String?,
);

Map<String, dynamic> _$ChannelForkSummaryToJson(ChannelForkSummary instance) => <String, dynamic>{
  'channel_cid': instance.channelCid,
  'copied_message_count': instance.copiedMessageCount,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'source_channel_cid': instance.sourceChannelCid,
  'source_message_id': instance.sourceMessageId,
  'status': instance.status,
  'task_id': instance.taskId,
};
