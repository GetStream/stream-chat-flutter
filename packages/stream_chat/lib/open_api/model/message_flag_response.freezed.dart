// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_flag_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageFlagResponse {
  DateTime? get approvedAt;
  DateTime get createdAt;
  bool get createdByAutomod;
  Map<String, Object?>? get custom;
  FlagDetailsResponse? get details;
  MessageResponse? get message;
  FlagFeedbackResponse? get moderationFeedback;
  MessageModerationResult? get moderationResult;
  String? get reason;
  DateTime? get rejectedAt;
  DateTime? get reviewedAt;
  UserResponse? get reviewedBy;
  DateTime get updatedAt;
  UserResponse? get user;

  /// Create a copy of MessageFlagResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageFlagResponseCopyWith<MessageFlagResponse> get copyWith =>
      _$MessageFlagResponseCopyWithImpl<MessageFlagResponse>(
        this as MessageFlagResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageFlagResponse &&
            (identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.createdByAutomod, createdByAutomod) || other.createdByAutomod == createdByAutomod) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.moderationFeedback, moderationFeedback) ||
                other.moderationFeedback == moderationFeedback) &&
            (identical(other.moderationResult, moderationResult) || other.moderationResult == moderationResult) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt) &&
            (identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt) &&
            (identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    approvedAt,
    createdAt,
    createdByAutomod,
    const DeepCollectionEquality().hash(custom),
    details,
    message,
    moderationFeedback,
    moderationResult,
    reason,
    rejectedAt,
    reviewedAt,
    reviewedBy,
    updatedAt,
    user,
  );

  @override
  String toString() {
    return 'MessageFlagResponse(approvedAt: $approvedAt, createdAt: $createdAt, createdByAutomod: $createdByAutomod, custom: $custom, details: $details, message: $message, moderationFeedback: $moderationFeedback, moderationResult: $moderationResult, reason: $reason, rejectedAt: $rejectedAt, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy, updatedAt: $updatedAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class $MessageFlagResponseCopyWith<$Res> {
  factory $MessageFlagResponseCopyWith(
    MessageFlagResponse value,
    $Res Function(MessageFlagResponse) _then,
  ) = _$MessageFlagResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime? approvedAt,
    DateTime createdAt,
    bool createdByAutomod,
    Map<String, Object?>? custom,
    FlagDetailsResponse? details,
    MessageResponse? message,
    FlagFeedbackResponse? moderationFeedback,
    MessageModerationResult? moderationResult,
    String? reason,
    DateTime? rejectedAt,
    DateTime? reviewedAt,
    UserResponse? reviewedBy,
    DateTime updatedAt,
    UserResponse? user,
  });
}

/// @nodoc
class _$MessageFlagResponseCopyWithImpl<$Res> implements $MessageFlagResponseCopyWith<$Res> {
  _$MessageFlagResponseCopyWithImpl(this._self, this._then);

  final MessageFlagResponse _self;
  final $Res Function(MessageFlagResponse) _then;

  /// Create a copy of MessageFlagResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? approvedAt = freezed,
    Object? createdAt = null,
    Object? createdByAutomod = null,
    Object? custom = freezed,
    Object? details = freezed,
    Object? message = freezed,
    Object? moderationFeedback = freezed,
    Object? moderationResult = freezed,
    Object? reason = freezed,
    Object? rejectedAt = freezed,
    Object? reviewedAt = freezed,
    Object? reviewedBy = freezed,
    Object? updatedAt = null,
    Object? user = freezed,
  }) {
    return _then(
      MessageFlagResponse(
        approvedAt: freezed == approvedAt
            ? _self.approvedAt
            : approvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdByAutomod: null == createdByAutomod
            ? _self.createdByAutomod
            : createdByAutomod // ignore: cast_nullable_to_non_nullable
                  as bool,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        details: freezed == details
            ? _self.details
            : details // ignore: cast_nullable_to_non_nullable
                  as FlagDetailsResponse?,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        moderationFeedback: freezed == moderationFeedback
            ? _self.moderationFeedback
            : moderationFeedback // ignore: cast_nullable_to_non_nullable
                  as FlagFeedbackResponse?,
        moderationResult: freezed == moderationResult
            ? _self.moderationResult
            : moderationResult // ignore: cast_nullable_to_non_nullable
                  as MessageModerationResult?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        rejectedAt: freezed == rejectedAt
            ? _self.rejectedAt
            : rejectedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewedAt: freezed == reviewedAt
            ? _self.reviewedAt
            : reviewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewedBy: freezed == reviewedBy
            ? _self.reviewedBy
            : reviewedBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
      ),
    );
  }
}
