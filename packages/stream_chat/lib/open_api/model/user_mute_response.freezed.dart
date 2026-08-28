// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_mute_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserMuteResponse {
  DateTime get createdAt;
  DateTime? get expires;
  UserResponse? get target;
  DateTime get updatedAt;
  UserResponse? get user;

  /// Create a copy of UserMuteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserMuteResponseCopyWith<UserMuteResponse> get copyWith =>
      _$UserMuteResponseCopyWithImpl<UserMuteResponse>(
        this as UserMuteResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserMuteResponse &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expires, expires) || other.expires == expires) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, createdAt, expires, target, updatedAt, user);

  @override
  String toString() {
    return 'UserMuteResponse(createdAt: $createdAt, expires: $expires, target: $target, updatedAt: $updatedAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserMuteResponseCopyWith<$Res> {
  factory $UserMuteResponseCopyWith(
    UserMuteResponse value,
    $Res Function(UserMuteResponse) _then,
  ) = _$UserMuteResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    DateTime? expires,
    UserResponse? target,
    DateTime updatedAt,
    UserResponse? user,
  });
}

/// @nodoc
class _$UserMuteResponseCopyWithImpl<$Res>
    implements $UserMuteResponseCopyWith<$Res> {
  _$UserMuteResponseCopyWithImpl(this._self, this._then);

  final UserMuteResponse _self;
  final $Res Function(UserMuteResponse) _then;

  /// Create a copy of UserMuteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? expires = freezed,
    Object? target = freezed,
    Object? updatedAt = null,
    Object? user = freezed,
  }) {
    return _then(
      UserMuteResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expires: freezed == expires
            ? _self.expires
            : expires // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        target: freezed == target
            ? _self.target
            : target // ignore: cast_nullable_to_non_nullable
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
