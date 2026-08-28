// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction_group_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReactionGroupUserResponse {
  DateTime get createdAt;
  UserResponse? get user;
  String get userId;

  /// Create a copy of ReactionGroupUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionGroupUserResponseCopyWith<ReactionGroupUserResponse> get copyWith =>
      _$ReactionGroupUserResponseCopyWithImpl<ReactionGroupUserResponse>(
        this as ReactionGroupUserResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionGroupUserResponse &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, createdAt, user, userId);

  @override
  String toString() {
    return 'ReactionGroupUserResponse(createdAt: $createdAt, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ReactionGroupUserResponseCopyWith<$Res> {
  factory $ReactionGroupUserResponseCopyWith(
    ReactionGroupUserResponse value,
    $Res Function(ReactionGroupUserResponse) _then,
  ) = _$ReactionGroupUserResponseCopyWithImpl;
  @useResult
  $Res call({DateTime createdAt, UserResponse? user, String userId});
}

/// @nodoc
class _$ReactionGroupUserResponseCopyWithImpl<$Res>
    implements $ReactionGroupUserResponseCopyWith<$Res> {
  _$ReactionGroupUserResponseCopyWithImpl(this._self, this._then);

  final ReactionGroupUserResponse _self;
  final $Res Function(ReactionGroupUserResponse) _then;

  /// Create a copy of ReactionGroupUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? user = freezed,
    Object? userId = null,
  }) {
    return _then(
      ReactionGroupUserResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
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
