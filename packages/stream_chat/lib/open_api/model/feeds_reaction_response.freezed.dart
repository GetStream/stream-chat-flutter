// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_reaction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedsReactionResponse {
  String get activityId;
  String? get commentId;
  DateTime get createdAt;
  Map<String, Object?>? get custom;
  String get type;
  DateTime get updatedAt;
  UserResponse get user;

  /// Create a copy of FeedsReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedsReactionResponseCopyWith<FeedsReactionResponse> get copyWith =>
      _$FeedsReactionResponseCopyWithImpl<FeedsReactionResponse>(
        this as FeedsReactionResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedsReactionResponse &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    commentId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    type,
    updatedAt,
    user,
  );

  @override
  String toString() {
    return 'FeedsReactionResponse(activityId: $activityId, commentId: $commentId, createdAt: $createdAt, custom: $custom, type: $type, updatedAt: $updatedAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class $FeedsReactionResponseCopyWith<$Res> {
  factory $FeedsReactionResponseCopyWith(
    FeedsReactionResponse value,
    $Res Function(FeedsReactionResponse) _then,
  ) = _$FeedsReactionResponseCopyWithImpl;
  @useResult
  $Res call({
    String activityId,
    String? commentId,
    DateTime createdAt,
    Map<String, Object?>? custom,
    String type,
    DateTime updatedAt,
    UserResponse user,
  });
}

/// @nodoc
class _$FeedsReactionResponseCopyWithImpl<$Res>
    implements $FeedsReactionResponseCopyWith<$Res> {
  _$FeedsReactionResponseCopyWithImpl(this._self, this._then);

  final FeedsReactionResponse _self;
  final $Res Function(FeedsReactionResponse) _then;

  /// Create a copy of FeedsReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
    Object? commentId = freezed,
    Object? createdAt = null,
    Object? custom = freezed,
    Object? type = null,
    Object? updatedAt = null,
    Object? user = null,
  }) {
    return _then(
      FeedsReactionResponse(
        activityId: null == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String,
        commentId: freezed == commentId
            ? _self.commentId
            : commentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
      ),
    );
  }
}
