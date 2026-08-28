// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedUserResponse {
  UserResponse get blockedUser;
  String get blockedUserId;
  DateTime get createdAt;
  UserResponse get user;
  String get userId;

  /// Create a copy of BlockedUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockedUserResponseCopyWith<BlockedUserResponse> get copyWith =>
      _$BlockedUserResponseCopyWithImpl<BlockedUserResponse>(
        this as BlockedUserResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockedUserResponse &&
            (identical(other.blockedUser, blockedUser) ||
                other.blockedUser == blockedUser) &&
            (identical(other.blockedUserId, blockedUserId) ||
                other.blockedUserId == blockedUserId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    blockedUser,
    blockedUserId,
    createdAt,
    user,
    userId,
  );

  @override
  String toString() {
    return 'BlockedUserResponse(blockedUser: $blockedUser, blockedUserId: $blockedUserId, createdAt: $createdAt, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $BlockedUserResponseCopyWith<$Res> {
  factory $BlockedUserResponseCopyWith(
    BlockedUserResponse value,
    $Res Function(BlockedUserResponse) _then,
  ) = _$BlockedUserResponseCopyWithImpl;
  @useResult
  $Res call({
    UserResponse blockedUser,
    String blockedUserId,
    DateTime createdAt,
    UserResponse user,
    String userId,
  });
}

/// @nodoc
class _$BlockedUserResponseCopyWithImpl<$Res>
    implements $BlockedUserResponseCopyWith<$Res> {
  _$BlockedUserResponseCopyWithImpl(this._self, this._then);

  final BlockedUserResponse _self;
  final $Res Function(BlockedUserResponse) _then;

  /// Create a copy of BlockedUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedUser = null,
    Object? blockedUserId = null,
    Object? createdAt = null,
    Object? user = null,
    Object? userId = null,
  }) {
    return _then(
      BlockedUserResponse(
        blockedUser: null == blockedUser
            ? _self.blockedUser
            : blockedUser // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
        blockedUserId: null == blockedUserId
            ? _self.blockedUserId
            : blockedUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
