// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_guest_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateGuestResponse {
  String get accessToken;
  String get duration;
  UserResponse get user;

  /// Create a copy of CreateGuestResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateGuestResponseCopyWith<CreateGuestResponse> get copyWith =>
      _$CreateGuestResponseCopyWithImpl<CreateGuestResponse>(
        this as CreateGuestResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateGuestResponse &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, accessToken, duration, user);

  @override
  String toString() {
    return 'CreateGuestResponse(accessToken: $accessToken, duration: $duration, user: $user)';
  }
}

/// @nodoc
abstract mixin class $CreateGuestResponseCopyWith<$Res> {
  factory $CreateGuestResponseCopyWith(
    CreateGuestResponse value,
    $Res Function(CreateGuestResponse) _then,
  ) = _$CreateGuestResponseCopyWithImpl;
  @useResult
  $Res call({String accessToken, String duration, UserResponse user});
}

/// @nodoc
class _$CreateGuestResponseCopyWithImpl<$Res>
    implements $CreateGuestResponseCopyWith<$Res> {
  _$CreateGuestResponseCopyWithImpl(this._self, this._then);

  final CreateGuestResponse _self;
  final $Res Function(CreateGuestResponse) _then;

  /// Create a copy of CreateGuestResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? duration = null,
    Object? user = null,
  }) {
    return _then(
      CreateGuestResponse(
        accessToken: null == accessToken
            ? _self.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
      ),
    );
  }
}
