// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_bookmark_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedsBookmarkResponse {
  String? get activityId;
  DateTime get createdAt;
  Map<String, Object?>? get custom;
  String get objectId;
  String get objectType;
  DateTime get updatedAt;
  UserResponse get user;

  /// Create a copy of FeedsBookmarkResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedsBookmarkResponseCopyWith<FeedsBookmarkResponse> get copyWith =>
      _$FeedsBookmarkResponseCopyWithImpl<FeedsBookmarkResponse>(
        this as FeedsBookmarkResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedsBookmarkResponse &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            (identical(other.objectType, objectType) ||
                other.objectType == objectType) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    objectId,
    objectType,
    updatedAt,
    user,
  );

  @override
  String toString() {
    return 'FeedsBookmarkResponse(activityId: $activityId, createdAt: $createdAt, custom: $custom, objectId: $objectId, objectType: $objectType, updatedAt: $updatedAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class $FeedsBookmarkResponseCopyWith<$Res> {
  factory $FeedsBookmarkResponseCopyWith(
    FeedsBookmarkResponse value,
    $Res Function(FeedsBookmarkResponse) _then,
  ) = _$FeedsBookmarkResponseCopyWithImpl;
  @useResult
  $Res call({
    String? activityId,
    DateTime createdAt,
    Map<String, Object?>? custom,
    String objectId,
    String objectType,
    DateTime updatedAt,
    UserResponse user,
  });
}

/// @nodoc
class _$FeedsBookmarkResponseCopyWithImpl<$Res>
    implements $FeedsBookmarkResponseCopyWith<$Res> {
  _$FeedsBookmarkResponseCopyWithImpl(this._self, this._then);

  final FeedsBookmarkResponse _self;
  final $Res Function(FeedsBookmarkResponse) _then;

  /// Create a copy of FeedsBookmarkResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = freezed,
    Object? createdAt = null,
    Object? custom = freezed,
    Object? objectId = null,
    Object? objectType = null,
    Object? updatedAt = null,
    Object? user = null,
  }) {
    return _then(
      FeedsBookmarkResponse(
        activityId: freezed == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        objectId: null == objectId
            ? _self.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String,
        objectType: null == objectType
            ? _self.objectType
            : objectType // ignore: cast_nullable_to_non_nullable
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
