// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connect_guest_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConnectGuestUserResponse {
  String get duration;
  String get accessToken;
  User get user;

  /// Create a copy of ConnectGuestUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConnectGuestUserResponseCopyWith<ConnectGuestUserResponse> get copyWith =>
      _$ConnectGuestUserResponseCopyWithImpl<ConnectGuestUserResponse>(
        this as ConnectGuestUserResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConnectGuestUserResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.accessToken, accessToken) || other.accessToken == accessToken) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, accessToken, user);

  @override
  String toString() {
    return 'ConnectGuestUserResponse(duration: $duration, accessToken: $accessToken, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ConnectGuestUserResponseCopyWith<$Res> {
  factory $ConnectGuestUserResponseCopyWith(
    ConnectGuestUserResponse value,
    $Res Function(ConnectGuestUserResponse) _then,
  ) = _$ConnectGuestUserResponseCopyWithImpl;
  @useResult
  $Res call({String duration, String accessToken, User user});
}

/// @nodoc
class _$ConnectGuestUserResponseCopyWithImpl<$Res> implements $ConnectGuestUserResponseCopyWith<$Res> {
  _$ConnectGuestUserResponseCopyWithImpl(this._self, this._then);

  final ConnectGuestUserResponse _self;
  final $Res Function(ConnectGuestUserResponse) _then;

  /// Create a copy of ConnectGuestUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? accessToken = null,
    Object? user = null,
  }) {
    return _then(
      ConnectGuestUserResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        accessToken: null == accessToken
            ? _self.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
      ),
    );
  }
}
