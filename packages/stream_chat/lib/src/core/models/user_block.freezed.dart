// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserBlock {
  User get user;
  User get blockedUser;
  String get userId;
  String get blockedUserId;
  DateTime get createdAt;

  /// Create a copy of UserBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserBlockCopyWith<UserBlock> get copyWith => _$UserBlockCopyWithImpl<UserBlock>(this as UserBlock, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserBlock &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.blockedUser, blockedUser) || other.blockedUser == blockedUser) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.blockedUserId, blockedUserId) || other.blockedUserId == blockedUserId) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    blockedUser,
    userId,
    blockedUserId,
    createdAt,
  );

  @override
  String toString() {
    return 'UserBlock(user: $user, blockedUser: $blockedUser, userId: $userId, blockedUserId: $blockedUserId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $UserBlockCopyWith<$Res> {
  factory $UserBlockCopyWith(UserBlock value, $Res Function(UserBlock) _then) = _$UserBlockCopyWithImpl;
  @useResult
  $Res call({
    User user,
    User blockedUser,
    String userId,
    String blockedUserId,
    DateTime createdAt,
  });
}

/// @nodoc
class _$UserBlockCopyWithImpl<$Res> implements $UserBlockCopyWith<$Res> {
  _$UserBlockCopyWithImpl(this._self, this._then);

  final UserBlock _self;
  final $Res Function(UserBlock) _then;

  /// Create a copy of UserBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? blockedUser = null,
    Object? userId = null,
    Object? blockedUserId = null,
    Object? createdAt = null,
  }) {
    return _then(
      UserBlock(
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        blockedUser: null == blockedUser
            ? _self.blockedUser
            : blockedUser // ignore: cast_nullable_to_non_nullable
                  as User,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        blockedUserId: null == blockedUserId
            ? _self.blockedUserId
            : blockedUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
