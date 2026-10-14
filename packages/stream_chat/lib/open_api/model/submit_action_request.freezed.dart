// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submit_action_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmitActionRequest {
  SubmitActionRequestActionType get actionType;
  String? get appealId;
  BanActionRequestPayload? get ban;
  BlockActionRequestPayload? get block;
  BypassActionRequest? get bypass;
  CustomActionRequestPayload? get custom;
  DeleteActivityRequestPayload? get deleteActivity;
  DeleteCommentRequestPayload? get deleteComment;
  DeleteMessageRequestPayload? get deleteMessage;
  DeleteReactionRequestPayload? get deleteReaction;
  DeleteUserRequestPayload? get deleteUser;
  DeleteUserMessagesRequestPayload? get deleteUserMessages;
  EscalatePayload? get escalate;
  FlagRequest? get flag;
  String? get itemId;
  MarkReviewedRequestPayload? get markReviewed;
  RejectAppealRequestPayload? get rejectAppeal;
  RestoreActionRequestPayload? get restore;
  ShadowBlockActionRequestPayload? get shadowBlock;
  UnbanActionRequestPayload? get unban;
  UnblockActionRequestPayload? get unblock;

  /// Create a copy of SubmitActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubmitActionRequestCopyWith<SubmitActionRequest> get copyWith =>
      _$SubmitActionRequestCopyWithImpl<SubmitActionRequest>(
        this as SubmitActionRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubmitActionRequest &&
            (identical(other.actionType, actionType) || other.actionType == actionType) &&
            (identical(other.appealId, appealId) || other.appealId == appealId) &&
            (identical(other.ban, ban) || other.ban == ban) &&
            (identical(other.block, block) || other.block == block) &&
            (identical(other.bypass, bypass) || other.bypass == bypass) &&
            (identical(other.custom, custom) || other.custom == custom) &&
            (identical(other.deleteActivity, deleteActivity) || other.deleteActivity == deleteActivity) &&
            (identical(other.deleteComment, deleteComment) || other.deleteComment == deleteComment) &&
            (identical(other.deleteMessage, deleteMessage) || other.deleteMessage == deleteMessage) &&
            (identical(other.deleteReaction, deleteReaction) || other.deleteReaction == deleteReaction) &&
            (identical(other.deleteUser, deleteUser) || other.deleteUser == deleteUser) &&
            (identical(other.deleteUserMessages, deleteUserMessages) ||
                other.deleteUserMessages == deleteUserMessages) &&
            (identical(other.escalate, escalate) || other.escalate == escalate) &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.markReviewed, markReviewed) || other.markReviewed == markReviewed) &&
            (identical(other.rejectAppeal, rejectAppeal) || other.rejectAppeal == rejectAppeal) &&
            (identical(other.restore, restore) || other.restore == restore) &&
            (identical(other.shadowBlock, shadowBlock) || other.shadowBlock == shadowBlock) &&
            (identical(other.unban, unban) || other.unban == unban) &&
            (identical(other.unblock, unblock) || other.unblock == unblock));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    actionType,
    appealId,
    ban,
    block,
    bypass,
    custom,
    deleteActivity,
    deleteComment,
    deleteMessage,
    deleteReaction,
    deleteUser,
    deleteUserMessages,
    escalate,
    flag,
    itemId,
    markReviewed,
    rejectAppeal,
    restore,
    shadowBlock,
    unban,
    unblock,
  ]);

  @override
  String toString() {
    return 'SubmitActionRequest(actionType: $actionType, appealId: $appealId, ban: $ban, block: $block, bypass: $bypass, custom: $custom, deleteActivity: $deleteActivity, deleteComment: $deleteComment, deleteMessage: $deleteMessage, deleteReaction: $deleteReaction, deleteUser: $deleteUser, deleteUserMessages: $deleteUserMessages, escalate: $escalate, flag: $flag, itemId: $itemId, markReviewed: $markReviewed, rejectAppeal: $rejectAppeal, restore: $restore, shadowBlock: $shadowBlock, unban: $unban, unblock: $unblock)';
  }
}

/// @nodoc
abstract mixin class $SubmitActionRequestCopyWith<$Res> {
  factory $SubmitActionRequestCopyWith(
    SubmitActionRequest value,
    $Res Function(SubmitActionRequest) _then,
  ) = _$SubmitActionRequestCopyWithImpl;
  @useResult
  $Res call({
    SubmitActionRequestActionType actionType,
    String? appealId,
    BanActionRequestPayload? ban,
    BlockActionRequestPayload? block,
    BypassActionRequest? bypass,
    CustomActionRequestPayload? custom,
    DeleteActivityRequestPayload? deleteActivity,
    DeleteCommentRequestPayload? deleteComment,
    DeleteMessageRequestPayload? deleteMessage,
    DeleteReactionRequestPayload? deleteReaction,
    DeleteUserRequestPayload? deleteUser,
    DeleteUserMessagesRequestPayload? deleteUserMessages,
    EscalatePayload? escalate,
    FlagRequest? flag,
    String? itemId,
    MarkReviewedRequestPayload? markReviewed,
    RejectAppealRequestPayload? rejectAppeal,
    RestoreActionRequestPayload? restore,
    ShadowBlockActionRequestPayload? shadowBlock,
    UnbanActionRequestPayload? unban,
    UnblockActionRequestPayload? unblock,
  });
}

/// @nodoc
class _$SubmitActionRequestCopyWithImpl<$Res> implements $SubmitActionRequestCopyWith<$Res> {
  _$SubmitActionRequestCopyWithImpl(this._self, this._then);

  final SubmitActionRequest _self;
  final $Res Function(SubmitActionRequest) _then;

  /// Create a copy of SubmitActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actionType = null,
    Object? appealId = freezed,
    Object? ban = freezed,
    Object? block = freezed,
    Object? bypass = freezed,
    Object? custom = freezed,
    Object? deleteActivity = freezed,
    Object? deleteComment = freezed,
    Object? deleteMessage = freezed,
    Object? deleteReaction = freezed,
    Object? deleteUser = freezed,
    Object? deleteUserMessages = freezed,
    Object? escalate = freezed,
    Object? flag = freezed,
    Object? itemId = freezed,
    Object? markReviewed = freezed,
    Object? rejectAppeal = freezed,
    Object? restore = freezed,
    Object? shadowBlock = freezed,
    Object? unban = freezed,
    Object? unblock = freezed,
  }) {
    return _then(
      SubmitActionRequest(
        actionType: null == actionType
            ? _self.actionType
            : actionType // ignore: cast_nullable_to_non_nullable
                  as SubmitActionRequestActionType,
        appealId: freezed == appealId
            ? _self.appealId
            : appealId // ignore: cast_nullable_to_non_nullable
                  as String?,
        ban: freezed == ban
            ? _self.ban
            : ban // ignore: cast_nullable_to_non_nullable
                  as BanActionRequestPayload?,
        block: freezed == block
            ? _self.block
            : block // ignore: cast_nullable_to_non_nullable
                  as BlockActionRequestPayload?,
        bypass: freezed == bypass
            ? _self.bypass
            : bypass // ignore: cast_nullable_to_non_nullable
                  as BypassActionRequest?,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as CustomActionRequestPayload?,
        deleteActivity: freezed == deleteActivity
            ? _self.deleteActivity
            : deleteActivity // ignore: cast_nullable_to_non_nullable
                  as DeleteActivityRequestPayload?,
        deleteComment: freezed == deleteComment
            ? _self.deleteComment
            : deleteComment // ignore: cast_nullable_to_non_nullable
                  as DeleteCommentRequestPayload?,
        deleteMessage: freezed == deleteMessage
            ? _self.deleteMessage
            : deleteMessage // ignore: cast_nullable_to_non_nullable
                  as DeleteMessageRequestPayload?,
        deleteReaction: freezed == deleteReaction
            ? _self.deleteReaction
            : deleteReaction // ignore: cast_nullable_to_non_nullable
                  as DeleteReactionRequestPayload?,
        deleteUser: freezed == deleteUser
            ? _self.deleteUser
            : deleteUser // ignore: cast_nullable_to_non_nullable
                  as DeleteUserRequestPayload?,
        deleteUserMessages: freezed == deleteUserMessages
            ? _self.deleteUserMessages
            : deleteUserMessages // ignore: cast_nullable_to_non_nullable
                  as DeleteUserMessagesRequestPayload?,
        escalate: freezed == escalate
            ? _self.escalate
            : escalate // ignore: cast_nullable_to_non_nullable
                  as EscalatePayload?,
        flag: freezed == flag
            ? _self.flag
            : flag // ignore: cast_nullable_to_non_nullable
                  as FlagRequest?,
        itemId: freezed == itemId
            ? _self.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        markReviewed: freezed == markReviewed
            ? _self.markReviewed
            : markReviewed // ignore: cast_nullable_to_non_nullable
                  as MarkReviewedRequestPayload?,
        rejectAppeal: freezed == rejectAppeal
            ? _self.rejectAppeal
            : rejectAppeal // ignore: cast_nullable_to_non_nullable
                  as RejectAppealRequestPayload?,
        restore: freezed == restore
            ? _self.restore
            : restore // ignore: cast_nullable_to_non_nullable
                  as RestoreActionRequestPayload?,
        shadowBlock: freezed == shadowBlock
            ? _self.shadowBlock
            : shadowBlock // ignore: cast_nullable_to_non_nullable
                  as ShadowBlockActionRequestPayload?,
        unban: freezed == unban
            ? _self.unban
            : unban // ignore: cast_nullable_to_non_nullable
                  as UnbanActionRequestPayload?,
        unblock: freezed == unblock
            ? _self.unblock
            : unblock // ignore: cast_nullable_to_non_nullable
                  as UnblockActionRequestPayload?,
      ),
    );
  }
}
