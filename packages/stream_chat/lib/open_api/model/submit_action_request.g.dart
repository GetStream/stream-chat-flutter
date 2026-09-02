// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_action_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitActionRequest _$SubmitActionRequestFromJson(
  Map<String, dynamic> json,
) => SubmitActionRequest(
  actionType: SubmitActionRequestActionType.fromJson(
    json['action_type'] as String,
  ),
  appealId: json['appeal_id'] as String?,
  ban: json['ban'] == null ? null : BanActionRequestPayload.fromJson(json['ban'] as Map<String, dynamic>),
  block: json['block'] == null
      ? null
      : BlockActionRequestPayload.fromJson(
          json['block'] as Map<String, dynamic>,
        ),
  bypass: json['bypass'] == null ? null : BypassActionRequest.fromJson(json['bypass'] as Map<String, dynamic>),
  custom: json['custom'] == null
      ? null
      : CustomActionRequestPayload.fromJson(
          json['custom'] as Map<String, dynamic>,
        ),
  deleteActivity: json['delete_activity'] == null
      ? null
      : DeleteActivityRequestPayload.fromJson(
          json['delete_activity'] as Map<String, dynamic>,
        ),
  deleteComment: json['delete_comment'] == null
      ? null
      : DeleteCommentRequestPayload.fromJson(
          json['delete_comment'] as Map<String, dynamic>,
        ),
  deleteMessage: json['delete_message'] == null
      ? null
      : DeleteMessageRequestPayload.fromJson(
          json['delete_message'] as Map<String, dynamic>,
        ),
  deleteReaction: json['delete_reaction'] == null
      ? null
      : DeleteReactionRequestPayload.fromJson(
          json['delete_reaction'] as Map<String, dynamic>,
        ),
  deleteUser: json['delete_user'] == null
      ? null
      : DeleteUserRequestPayload.fromJson(
          json['delete_user'] as Map<String, dynamic>,
        ),
  deleteUserMessages: json['delete_user_messages'] == null
      ? null
      : DeleteUserMessagesRequestPayload.fromJson(
          json['delete_user_messages'] as Map<String, dynamic>,
        ),
  escalate: json['escalate'] == null ? null : EscalatePayload.fromJson(json['escalate'] as Map<String, dynamic>),
  flag: json['flag'] == null ? null : FlagRequest.fromJson(json['flag'] as Map<String, dynamic>),
  itemId: json['item_id'] as String?,
  markReviewed: json['mark_reviewed'] == null
      ? null
      : MarkReviewedRequestPayload.fromJson(
          json['mark_reviewed'] as Map<String, dynamic>,
        ),
  rejectAppeal: json['reject_appeal'] == null
      ? null
      : RejectAppealRequestPayload.fromJson(
          json['reject_appeal'] as Map<String, dynamic>,
        ),
  restore: json['restore'] == null
      ? null
      : RestoreActionRequestPayload.fromJson(
          json['restore'] as Map<String, dynamic>,
        ),
  shadowBlock: json['shadow_block'] == null
      ? null
      : ShadowBlockActionRequestPayload.fromJson(
          json['shadow_block'] as Map<String, dynamic>,
        ),
  unban: json['unban'] == null
      ? null
      : UnbanActionRequestPayload.fromJson(
          json['unban'] as Map<String, dynamic>,
        ),
  unblock: json['unblock'] == null
      ? null
      : UnblockActionRequestPayload.fromJson(
          json['unblock'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SubmitActionRequestToJson(
  SubmitActionRequest instance,
) => <String, dynamic>{
  'action_type': instance.actionType.toJson(),
  'appeal_id': instance.appealId,
  'ban': instance.ban?.toJson(),
  'block': instance.block?.toJson(),
  'bypass': instance.bypass?.toJson(),
  'custom': instance.custom?.toJson(),
  'delete_activity': instance.deleteActivity?.toJson(),
  'delete_comment': instance.deleteComment?.toJson(),
  'delete_message': instance.deleteMessage?.toJson(),
  'delete_reaction': instance.deleteReaction?.toJson(),
  'delete_user': instance.deleteUser?.toJson(),
  'delete_user_messages': instance.deleteUserMessages?.toJson(),
  'escalate': instance.escalate?.toJson(),
  'flag': instance.flag?.toJson(),
  'item_id': instance.itemId,
  'mark_reviewed': instance.markReviewed?.toJson(),
  'reject_appeal': instance.rejectAppeal?.toJson(),
  'restore': instance.restore?.toJson(),
  'shadow_block': instance.shadowBlock?.toJson(),
  'unban': instance.unban?.toJson(),
  'unblock': instance.unblock?.toJson(),
};
