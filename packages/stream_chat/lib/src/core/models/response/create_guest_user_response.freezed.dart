// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_guest_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateGuestUserResponse {
  String get duration;
  String get accessToken;
  User get user;

  /// Create a copy of CreateGuestUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateGuestUserResponseCopyWith<CreateGuestUserResponse> get copyWith =>
      _$CreateGuestUserResponseCopyWithImpl<CreateGuestUserResponse>(this as CreateGuestUserResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateGuestUserResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.accessToken, accessToken) || other.accessToken == accessToken) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, accessToken, user);

  @override
  String toString() {
    return 'CreateGuestUserResponse(duration: $duration, accessToken: $accessToken, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CreateGuestUserResponseCopyWith<$Res> {
  factory $CreateGuestUserResponseCopyWith(
    CreateGuestUserResponse value,
    $Res Function(CreateGuestUserResponse) _then,
  ) = _$CreateGuestUserResponseCopyWithImpl;
  @useResult
  $Res call({String duration, String accessToken, User user});
}

/// @nodoc
class _$CreateGuestUserResponseCopyWithImpl<$Res> implements $CreateGuestUserResponseCopyWith<$Res> {
  _$CreateGuestUserResponseCopyWithImpl(this._self, this._then);

  final CreateGuestUserResponse _self;
  final $Res Function(CreateGuestUserResponse) _then;

  /// Create a copy of CreateGuestUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? accessToken = null, Object? user = null}) {
    return _then(
      CreateGuestUserResponse(
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
