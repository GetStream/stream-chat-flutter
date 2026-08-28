// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_type_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallTypeRuleParameters {
  String? get callType;

  /// Create a copy of CallTypeRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallTypeRuleParametersCopyWith<CallTypeRuleParameters> get copyWith =>
      _$CallTypeRuleParametersCopyWithImpl<CallTypeRuleParameters>(
        this as CallTypeRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallTypeRuleParameters &&
            (identical(other.callType, callType) ||
                other.callType == callType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callType);

  @override
  String toString() {
    return 'CallTypeRuleParameters(callType: $callType)';
  }
}

/// @nodoc
abstract mixin class $CallTypeRuleParametersCopyWith<$Res> {
  factory $CallTypeRuleParametersCopyWith(
    CallTypeRuleParameters value,
    $Res Function(CallTypeRuleParameters) _then,
  ) = _$CallTypeRuleParametersCopyWithImpl;
  @useResult
  $Res call({String? callType});
}

/// @nodoc
class _$CallTypeRuleParametersCopyWithImpl<$Res>
    implements $CallTypeRuleParametersCopyWith<$Res> {
  _$CallTypeRuleParametersCopyWithImpl(this._self, this._then);

  final CallTypeRuleParameters _self;
  final $Res Function(CallTypeRuleParameters) _then;

  /// Create a copy of CallTypeRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? callType = freezed}) {
    return _then(
      CallTypeRuleParameters(
        callType: freezed == callType
            ? _self.callType
            : callType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
