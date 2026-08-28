// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ip_flag_count_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IPFlagCountRuleParameters {
  List<String>? get harmLabels;
  String? get severity;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of IPFlagCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IPFlagCountRuleParametersCopyWith<IPFlagCountRuleParameters> get copyWith =>
      _$IPFlagCountRuleParametersCopyWithImpl<IPFlagCountRuleParameters>(
        this as IPFlagCountRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IPFlagCountRuleParameters &&
            const DeepCollectionEquality().equals(
              other.harmLabels,
              harmLabels,
            ) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) ||
                other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(harmLabels),
    severity,
    threshold,
    timeWindow,
  );

  @override
  String toString() {
    return 'IPFlagCountRuleParameters(harmLabels: $harmLabels, severity: $severity, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $IPFlagCountRuleParametersCopyWith<$Res> {
  factory $IPFlagCountRuleParametersCopyWith(
    IPFlagCountRuleParameters value,
    $Res Function(IPFlagCountRuleParameters) _then,
  ) = _$IPFlagCountRuleParametersCopyWithImpl;
  @useResult
  $Res call({
    List<String>? harmLabels,
    String? severity,
    int? threshold,
    String? timeWindow,
  });
}

/// @nodoc
class _$IPFlagCountRuleParametersCopyWithImpl<$Res>
    implements $IPFlagCountRuleParametersCopyWith<$Res> {
  _$IPFlagCountRuleParametersCopyWithImpl(this._self, this._then);

  final IPFlagCountRuleParameters _self;
  final $Res Function(IPFlagCountRuleParameters) _then;

  /// Create a copy of IPFlagCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? harmLabels = freezed,
    Object? severity = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      IPFlagCountRuleParameters(
        harmLabels: freezed == harmLabels
            ? _self.harmLabels
            : harmLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        severity: freezed == severity
            ? _self.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String?,
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
