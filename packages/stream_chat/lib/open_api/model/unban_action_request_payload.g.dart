// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unban_action_request_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnbanActionRequestPayload _$UnbanActionRequestPayloadFromJson(
  Map<String, dynamic> json,
) => UnbanActionRequestPayload(
  channelCid: json['channel_cid'] as String?,
  decisionReason: json['decision_reason'] as String?,
  removeFutureChannelsBan: json['remove_future_channels_ban'] as bool?,
  targetUserId: json['target_user_id'] as String?,
);

Map<String, dynamic> _$UnbanActionRequestPayloadToJson(
  UnbanActionRequestPayload instance,
) => <String, dynamic>{
  'channel_cid': instance.channelCid,
  'decision_reason': instance.decisionReason,
  'remove_future_channels_ban': instance.removeFutureChannelsBan,
  'target_user_id': instance.targetUserId,
};
