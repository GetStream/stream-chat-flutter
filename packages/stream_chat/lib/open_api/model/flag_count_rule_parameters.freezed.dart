// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flag_count_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FlagCountRuleParameters {
  int? get threshold;

  /// Create a copy of FlagCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FlagCountRuleParametersCopyWith<FlagCountRuleParameters> get copyWith =>
      _$FlagCountRuleParametersCopyWithImpl<FlagCountRuleParameters>(
        this as FlagCountRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FlagCountRuleParameters &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold));
  }

  @override
  int get hashCode => Object.hash(runtimeType, threshold);

  @override
  String toString() {
    return 'FlagCountRuleParameters(threshold: $threshold)';
  }
}

/// @nodoc
abstract mixin class $FlagCountRuleParametersCopyWith<$Res> {
  factory $FlagCountRuleParametersCopyWith(
    FlagCountRuleParameters value,
    $Res Function(FlagCountRuleParameters) _then,
  ) = _$FlagCountRuleParametersCopyWithImpl;
  @useResult
  $Res call({int? threshold});
}

/// @nodoc
class _$FlagCountRuleParametersCopyWithImpl<$Res>
    implements $FlagCountRuleParametersCopyWith<$Res> {
  _$FlagCountRuleParametersCopyWithImpl(this._self, this._then);

  final FlagCountRuleParameters _self;
  final $Res Function(FlagCountRuleParameters) _then;

  /// Create a copy of FlagCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? threshold = freezed}) {
    return _then(
      FlagCountRuleParameters(
        threshold: freezed == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
