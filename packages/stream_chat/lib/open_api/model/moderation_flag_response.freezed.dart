// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_flag_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModerationFlagResponse {
  DateTime get createdAt;
  Map<String, Object?>? get custom;
  String? get entityCreatorId;
  String get entityId;
  String get entityType;
  List<String>? get labels;
  ModerationPayloadResponse? get moderationPayload;
  String? get reason;
  List<Map<String, Object?>> get result;
  ReviewQueueItemResponse? get reviewQueueItem;
  String? get reviewQueueItemId;
  String get type;
  DateTime get updatedAt;
  UserResponse? get user;
  String get userId;

  /// Create a copy of ModerationFlagResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationFlagResponseCopyWith<ModerationFlagResponse> get copyWith =>
      _$ModerationFlagResponseCopyWithImpl<ModerationFlagResponse>(
        this as ModerationFlagResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationFlagResponse &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.entityCreatorId, entityCreatorId) ||
                other.entityCreatorId == entityCreatorId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            const DeepCollectionEquality().equals(other.labels, labels) &&
            (identical(other.moderationPayload, moderationPayload) ||
                other.moderationPayload == moderationPayload) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality().equals(other.result, result) &&
            (identical(other.reviewQueueItem, reviewQueueItem) ||
                other.reviewQueueItem == reviewQueueItem) &&
            (identical(other.reviewQueueItemId, reviewQueueItemId) ||
                other.reviewQueueItemId == reviewQueueItemId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    entityCreatorId,
    entityId,
    entityType,
    const DeepCollectionEquality().hash(labels),
    moderationPayload,
    reason,
    const DeepCollectionEquality().hash(result),
    reviewQueueItem,
    reviewQueueItemId,
    type,
    updatedAt,
    user,
    userId,
  );

  @override
  String toString() {
    return 'ModerationFlagResponse(createdAt: $createdAt, custom: $custom, entityCreatorId: $entityCreatorId, entityId: $entityId, entityType: $entityType, labels: $labels, moderationPayload: $moderationPayload, reason: $reason, result: $result, reviewQueueItem: $reviewQueueItem, reviewQueueItemId: $reviewQueueItemId, type: $type, updatedAt: $updatedAt, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ModerationFlagResponseCopyWith<$Res> {
  factory $ModerationFlagResponseCopyWith(
    ModerationFlagResponse value,
    $Res Function(ModerationFlagResponse) _then,
  ) = _$ModerationFlagResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?>? custom,
    String? entityCreatorId,
    String entityId,
    String entityType,
    List<String>? labels,
    ModerationPayloadResponse? moderationPayload,
    String? reason,
    List<Map<String, Object?>> result,
    ReviewQueueItemResponse? reviewQueueItem,
    String? reviewQueueItemId,
    String type,
    DateTime updatedAt,
    UserResponse? user,
    String userId,
  });
}

/// @nodoc
class _$ModerationFlagResponseCopyWithImpl<$Res>
    implements $ModerationFlagResponseCopyWith<$Res> {
  _$ModerationFlagResponseCopyWithImpl(this._self, this._then);

  final ModerationFlagResponse _self;
  final $Res Function(ModerationFlagResponse) _then;

  /// Create a copy of ModerationFlagResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = freezed,
    Object? entityCreatorId = freezed,
    Object? entityId = null,
    Object? entityType = null,
    Object? labels = freezed,
    Object? moderationPayload = freezed,
    Object? reason = freezed,
    Object? result = null,
    Object? reviewQueueItem = freezed,
    Object? reviewQueueItemId = freezed,
    Object? type = null,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? userId = null,
  }) {
    return _then(
      ModerationFlagResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        entityCreatorId: freezed == entityCreatorId
            ? _self.entityCreatorId
            : entityCreatorId // ignore: cast_nullable_to_non_nullable
                  as String?,
        entityId: null == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        labels: freezed == labels
            ? _self.labels
            : labels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        moderationPayload: freezed == moderationPayload
            ? _self.moderationPayload
            : moderationPayload // ignore: cast_nullable_to_non_nullable
                  as ModerationPayloadResponse?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        result: null == result
            ? _self.result
            : result // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, Object?>>,
        reviewQueueItem: freezed == reviewQueueItem
            ? _self.reviewQueueItem
            : reviewQueueItem // ignore: cast_nullable_to_non_nullable
                  as ReviewQueueItemResponse?,
        reviewQueueItemId: freezed == reviewQueueItemId
            ? _self.reviewQueueItemId
            : reviewQueueItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
