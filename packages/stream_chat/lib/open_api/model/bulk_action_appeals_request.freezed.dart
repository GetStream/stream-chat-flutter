// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_action_appeals_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkActionAppealsRequest {
  BulkActionAppealsRequestActionType get actionType;
  List<String> get appealIds;
  MarkReviewedRequestPayload? get markReviewed;
  RejectAppealRequestPayload? get rejectAppeal;
  RestoreActionRequestPayload? get restore;
  UnbanActionRequestPayload? get unban;
  UnblockActionRequestPayload? get unblock;

  /// Create a copy of BulkActionAppealsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BulkActionAppealsRequestCopyWith<BulkActionAppealsRequest> get copyWith =>
      _$BulkActionAppealsRequestCopyWithImpl<BulkActionAppealsRequest>(
        this as BulkActionAppealsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BulkActionAppealsRequest &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            const DeepCollectionEquality().equals(other.appealIds, appealIds) &&
            (identical(other.markReviewed, markReviewed) ||
                other.markReviewed == markReviewed) &&
            (identical(other.rejectAppeal, rejectAppeal) ||
                other.rejectAppeal == rejectAppeal) &&
            (identical(other.restore, restore) || other.restore == restore) &&
            (identical(other.unban, unban) || other.unban == unban) &&
            (identical(other.unblock, unblock) || other.unblock == unblock));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    actionType,
    const DeepCollectionEquality().hash(appealIds),
    markReviewed,
    rejectAppeal,
    restore,
    unban,
    unblock,
  );

  @override
  String toString() {
    return 'BulkActionAppealsRequest(actionType: $actionType, appealIds: $appealIds, markReviewed: $markReviewed, rejectAppeal: $rejectAppeal, restore: $restore, unban: $unban, unblock: $unblock)';
  }
}

/// @nodoc
abstract mixin class $BulkActionAppealsRequestCopyWith<$Res> {
  factory $BulkActionAppealsRequestCopyWith(
    BulkActionAppealsRequest value,
    $Res Function(BulkActionAppealsRequest) _then,
  ) = _$BulkActionAppealsRequestCopyWithImpl;
  @useResult
  $Res call({
    BulkActionAppealsRequestActionType actionType,
    List<String> appealIds,
    MarkReviewedRequestPayload? markReviewed,
    RejectAppealRequestPayload? rejectAppeal,
    RestoreActionRequestPayload? restore,
    UnbanActionRequestPayload? unban,
    UnblockActionRequestPayload? unblock,
  });
}

/// @nodoc
class _$BulkActionAppealsRequestCopyWithImpl<$Res>
    implements $BulkActionAppealsRequestCopyWith<$Res> {
  _$BulkActionAppealsRequestCopyWithImpl(this._self, this._then);

  final BulkActionAppealsRequest _self;
  final $Res Function(BulkActionAppealsRequest) _then;

  /// Create a copy of BulkActionAppealsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actionType = null,
    Object? appealIds = null,
    Object? markReviewed = freezed,
    Object? rejectAppeal = freezed,
    Object? restore = freezed,
    Object? unban = freezed,
    Object? unblock = freezed,
  }) {
    return _then(
      BulkActionAppealsRequest(
        actionType: null == actionType
            ? _self.actionType
            : actionType // ignore: cast_nullable_to_non_nullable
                  as BulkActionAppealsRequestActionType,
        appealIds: null == appealIds
            ? _self.appealIds
            : appealIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
