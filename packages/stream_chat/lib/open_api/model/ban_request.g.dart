// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ban_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanRequest _$BanRequestFromJson(Map<String, dynamic> json) => BanRequest(
  bannedBy: json['banned_by'] == null ? null : UserRequest.fromJson(json['banned_by'] as Map<String, dynamic>),
  bannedById: json['banned_by_id'] as String?,
  channelCid: json['channel_cid'] as String?,
  deleteMessages: json['delete_messages'] == null
      ? null
      : BanRequestDeleteMessages.fromJson(json['delete_messages'] as String),
  ipBan: json['ip_ban'] as bool?,
  reason: json['reason'] as String?,
  shadow: json['shadow'] as bool?,
  targetUserId: json['target_user_id'] as String,
  timeout: (json['timeout'] as num?)?.toInt(),
);

Map<String, dynamic> _$BanRequestToJson(BanRequest instance) => <String, dynamic>{
  'banned_by': instance.bannedBy?.toJson(),
  'banned_by_id': instance.bannedById,
  'channel_cid': instance.channelCid,
  'delete_messages': instance.deleteMessages?.toJson(),
  'ip_ban': instance.ipBan,
  'reason': instance.reason,
  'shadow': instance.shadow,
  'target_user_id': instance.targetUserId,
  'timeout': instance.timeout,
};
