// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ban_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanRequest _$BanRequestFromJson(Map<String, dynamic> json) => BanRequest(
  banFromFutureChannels: json['ban_from_future_channels'] as bool?,
  channelCid: json['channel_cid'] as String?,
  deleteMessages: json['delete_messages'] == null ? null : DeleteMessages.fromJson(json['delete_messages'] as String),
  deleteReactions: json['delete_reactions'] as bool?,
  ipBan: json['ip_ban'] as bool?,
  reason: json['reason'] as String?,
  shadow: json['shadow'] as bool?,
  targetUserId: json['target_user_id'] as String,
  timeout: (json['timeout'] as num?)?.toInt(),
);

Map<String, dynamic> _$BanRequestToJson(BanRequest instance) => <String, dynamic>{
  'ban_from_future_channels': instance.banFromFutureChannels,
  'channel_cid': instance.channelCid,
  'delete_messages': instance.deleteMessages?.toJson(),
  'delete_reactions': instance.deleteReactions,
  'ip_ban': instance.ipBan,
  'reason': instance.reason,
  'shadow': instance.shadow,
  'target_user_id': instance.targetUserId,
  'timeout': instance.timeout,
};
