// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_created_within_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserCreatedWithinParameters {
  String? get maxAge;

  /// Create a copy of UserCreatedWithinParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserCreatedWithinParametersCopyWith<UserCreatedWithinParameters>
  get copyWith =>
      _$UserCreatedWithinParametersCopyWithImpl<UserCreatedWithinParameters>(
        this as UserCreatedWithinParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserCreatedWithinParameters &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge));
  }

  @override
  int get hashCode => Object.hash(runtimeType, maxAge);

  @override
  String toString() {
    return 'UserCreatedWithinParameters(maxAge: $maxAge)';
  }
}

/// @nodoc
abstract mixin class $UserCreatedWithinParametersCopyWith<$Res> {
  factory $UserCreatedWithinParametersCopyWith(
    UserCreatedWithinParameters value,
    $Res Function(UserCreatedWithinParameters) _then,
  ) = _$UserCreatedWithinParametersCopyWithImpl;
  @useResult
  $Res call({String? maxAge});
}

/// @nodoc
class _$UserCreatedWithinParametersCopyWithImpl<$Res>
    implements $UserCreatedWithinParametersCopyWith<$Res> {
  _$UserCreatedWithinParametersCopyWithImpl(this._self, this._then);

  final UserCreatedWithinParameters _self;
  final $Res Function(UserCreatedWithinParameters) _then;

  /// Create a copy of UserCreatedWithinParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? maxAge = freezed}) {
    return _then(
      UserCreatedWithinParameters(
        maxAge: freezed == maxAge
            ? _self.maxAge
            : maxAge // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
