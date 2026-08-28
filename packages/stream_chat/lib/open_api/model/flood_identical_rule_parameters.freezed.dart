// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flood_identical_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FloodIdenticalRuleParameters {
  List<String>? get allowlist;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of FloodIdenticalRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FloodIdenticalRuleParametersCopyWith<FloodIdenticalRuleParameters> get copyWith =>
      _$FloodIdenticalRuleParametersCopyWithImpl<FloodIdenticalRuleParameters>(
        this as FloodIdenticalRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FloodIdenticalRuleParameters &&
            const DeepCollectionEquality().equals(other.allowlist, allowlist) &&
            (identical(other.threshold, threshold) || other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(allowlist),
    threshold,
    timeWindow,
  );

  @override
  String toString() {
    return 'FloodIdenticalRuleParameters(allowlist: $allowlist, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $FloodIdenticalRuleParametersCopyWith<$Res> {
  factory $FloodIdenticalRuleParametersCopyWith(
    FloodIdenticalRuleParameters value,
    $Res Function(FloodIdenticalRuleParameters) _then,
  ) = _$FloodIdenticalRuleParametersCopyWithImpl;
  @useResult
  $Res call({List<String>? allowlist, int? threshold, String? timeWindow});
}

/// @nodoc
class _$FloodIdenticalRuleParametersCopyWithImpl<$Res> implements $FloodIdenticalRuleParametersCopyWith<$Res> {
  _$FloodIdenticalRuleParametersCopyWithImpl(this._self, this._then);

  final FloodIdenticalRuleParameters _self;
  final $Res Function(FloodIdenticalRuleParameters) _then;

  /// Create a copy of FloodIdenticalRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowlist = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      FloodIdenticalRuleParameters(
        allowlist: freezed == allowlist
            ? _self.allowlist
            : allowlist // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        threshold: freezed == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int?,
        timeWindow: freezed == timeWindow
            ? _self.timeWindow
            : timeWindow // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
