// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_guest_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateGuestRequest {
  UserRequest get user;

  /// Create a copy of CreateGuestRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateGuestRequestCopyWith<CreateGuestRequest> get copyWith =>
      _$CreateGuestRequestCopyWithImpl<CreateGuestRequest>(
        this as CreateGuestRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateGuestRequest &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @override
  String toString() {
    return 'CreateGuestRequest(user: $user)';
  }
}

/// @nodoc
abstract mixin class $CreateGuestRequestCopyWith<$Res> {
  factory $CreateGuestRequestCopyWith(
    CreateGuestRequest value,
    $Res Function(CreateGuestRequest) _then,
  ) = _$CreateGuestRequestCopyWithImpl;
  @useResult
  $Res call({UserRequest user});
}

/// @nodoc
class _$CreateGuestRequestCopyWithImpl<$Res>
    implements $CreateGuestRequestCopyWith<$Res> {
  _$CreateGuestRequestCopyWithImpl(this._self, this._then);

  final CreateGuestRequest _self;
  final $Res Function(CreateGuestRequest) _then;

  /// Create a copy of CreateGuestRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      CreateGuestRequest(
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserRequest,
      ),
    );
  }
}
