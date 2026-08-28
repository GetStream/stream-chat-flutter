// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_log_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActionLogResponse {
  List<String> get aiProviders;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get id;
  String get reason;
  String get reporterType;
  ReviewQueueItemResponse? get reviewQueueItem;
  UserResponse? get targetUser;
  String get targetUserId;
  String get type;
  UserResponse? get user;
  String get userId;

  /// Create a copy of ActionLogResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActionLogResponseCopyWith<ActionLogResponse> get copyWith =>
      _$ActionLogResponseCopyWithImpl<ActionLogResponse>(
        this as ActionLogResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActionLogResponse &&
            const DeepCollectionEquality().equals(
              other.aiProviders,
              aiProviders,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.reporterType, reporterType) ||
                other.reporterType == reporterType) &&
            (identical(other.reviewQueueItem, reviewQueueItem) ||
                other.reviewQueueItem == reviewQueueItem) &&
            (identical(other.targetUser, targetUser) ||
                other.targetUser == targetUser) &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(aiProviders),
    createdAt,
    const DeepCollectionEquality().hash(custom),
    id,
    reason,
    reporterType,
    reviewQueueItem,
    targetUser,
    targetUserId,
    type,
    user,
    userId,
  );

  @override
  String toString() {
    return 'ActionLogResponse(aiProviders: $aiProviders, createdAt: $createdAt, custom: $custom, id: $id, reason: $reason, reporterType: $reporterType, reviewQueueItem: $reviewQueueItem, targetUser: $targetUser, targetUserId: $targetUserId, type: $type, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ActionLogResponseCopyWith<$Res> {
  factory $ActionLogResponseCopyWith(
    ActionLogResponse value,
    $Res Function(ActionLogResponse) _then,
  ) = _$ActionLogResponseCopyWithImpl;
  @useResult
  $Res call({
    List<String> aiProviders,
    DateTime createdAt,
    Map<String, Object?> custom,
    String id,
    String reason,
    String reporterType,
    ReviewQueueItemResponse? reviewQueueItem,
    UserResponse? targetUser,
    String targetUserId,
    String type,
    UserResponse? user,
    String userId,
  });
}

/// @nodoc
class _$ActionLogResponseCopyWithImpl<$Res>
    implements $ActionLogResponseCopyWith<$Res> {
  _$ActionLogResponseCopyWithImpl(this._self, this._then);

  final ActionLogResponse _self;
  final $Res Function(ActionLogResponse) _then;

  /// Create a copy of ActionLogResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiProviders = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? id = null,
    Object? reason = null,
    Object? reporterType = null,
    Object? reviewQueueItem = freezed,
    Object? targetUser = freezed,
    Object? targetUserId = null,
    Object? type = null,
    Object? user = freezed,
    Object? userId = null,
  }) {
    return _then(
      ActionLogResponse(
        aiProviders: null == aiProviders
            ? _self.aiProviders
            : aiProviders // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        reporterType: null == reporterType
            ? _self.reporterType
            : reporterType // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewQueueItem: freezed == reviewQueueItem
            ? _self.reviewQueueItem
            : reviewQueueItem // ignore: cast_nullable_to_non_nullable
                  as ReviewQueueItemResponse?,
        targetUser: freezed == targetUser
            ? _self.targetUser
            : targetUser // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        targetUserId: null == targetUserId
            ? _self.targetUserId
            : targetUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
