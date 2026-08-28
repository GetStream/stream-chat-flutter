// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRoleParameters {
  String? get operator;
  String? get role;

  /// Create a copy of UserRoleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserRoleParametersCopyWith<UserRoleParameters> get copyWith =>
      _$UserRoleParametersCopyWithImpl<UserRoleParameters>(
        this as UserRoleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserRoleParameters &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.role, role) || other.role == role));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operator, role);

  @override
  String toString() {
    return 'UserRoleParameters(operator: $operator, role: $role)';
  }
}

/// @nodoc
abstract mixin class $UserRoleParametersCopyWith<$Res> {
  factory $UserRoleParametersCopyWith(
    UserRoleParameters value,
    $Res Function(UserRoleParameters) _then,
  ) = _$UserRoleParametersCopyWithImpl;
  @useResult
  $Res call({String? operator, String? role});
}

/// @nodoc
class _$UserRoleParametersCopyWithImpl<$Res>
    implements $UserRoleParametersCopyWith<$Res> {
  _$UserRoleParametersCopyWithImpl(this._self, this._then);

  final UserRoleParameters _self;
  final $Res Function(UserRoleParameters) _then;

  /// Create a copy of UserRoleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? operator = freezed, Object? role = freezed}) {
    return _then(
      UserRoleParameters(
        operator: freezed == operator
            ? _self.operator
            : operator // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: freezed == role
            ? _self.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
