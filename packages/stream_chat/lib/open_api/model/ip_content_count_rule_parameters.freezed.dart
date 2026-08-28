// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ip_content_count_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IPContentCountRuleParameters {
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of IPContentCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IPContentCountRuleParametersCopyWith<IPContentCountRuleParameters>
  get copyWith =>
      _$IPContentCountRuleParametersCopyWithImpl<IPContentCountRuleParameters>(
        this as IPContentCountRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IPContentCountRuleParameters &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) ||
                other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(runtimeType, threshold, timeWindow);

  @override
  String toString() {
    return 'IPContentCountRuleParameters(threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $IPContentCountRuleParametersCopyWith<$Res> {
  factory $IPContentCountRuleParametersCopyWith(
    IPContentCountRuleParameters value,
    $Res Function(IPContentCountRuleParameters) _then,
  ) = _$IPContentCountRuleParametersCopyWithImpl;
  @useResult
  $Res call({int? threshold, String? timeWindow});
}

/// @nodoc
class _$IPContentCountRuleParametersCopyWithImpl<$Res>
    implements $IPContentCountRuleParametersCopyWith<$Res> {
  _$IPContentCountRuleParametersCopyWithImpl(this._self, this._then);

  final IPContentCountRuleParameters _self;
  final $Res Function(IPContentCountRuleParameters) _then;

  /// Create a copy of IPContentCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? threshold = freezed, Object? timeWindow = freezed}) {
    return _then(
      IPContentCountRuleParameters(
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
