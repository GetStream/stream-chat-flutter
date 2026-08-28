// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRuleParameters {
  String? get maxAge;

  /// Create a copy of UserRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserRuleParametersCopyWith<UserRuleParameters> get copyWith =>
      _$UserRuleParametersCopyWithImpl<UserRuleParameters>(
        this as UserRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserRuleParameters &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge));
  }

  @override
  int get hashCode => Object.hash(runtimeType, maxAge);

  @override
  String toString() {
    return 'UserRuleParameters(maxAge: $maxAge)';
  }
}

/// @nodoc
abstract mixin class $UserRuleParametersCopyWith<$Res> {
  factory $UserRuleParametersCopyWith(
    UserRuleParameters value,
    $Res Function(UserRuleParameters) _then,
  ) = _$UserRuleParametersCopyWithImpl;
  @useResult
  $Res call({String? maxAge});
}

/// @nodoc
class _$UserRuleParametersCopyWithImpl<$Res>
    implements $UserRuleParametersCopyWith<$Res> {
  _$UserRuleParametersCopyWithImpl(this._self, this._then);

  final UserRuleParameters _self;
  final $Res Function(UserRuleParameters) _then;

  /// Create a copy of UserRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? maxAge = freezed}) {
    return _then(
      UserRuleParameters(
        maxAge: freezed == maxAge
            ? _self.maxAge
            : maxAge // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
