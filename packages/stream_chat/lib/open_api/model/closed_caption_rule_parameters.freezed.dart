// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'closed_caption_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClosedCaptionRuleParameters {
  List<String>? get harmLabels;
  Map<String, String>? get llmHarmLabels;
  String? get severity;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of ClosedCaptionRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClosedCaptionRuleParametersCopyWith<ClosedCaptionRuleParameters>
  get copyWith =>
      _$ClosedCaptionRuleParametersCopyWithImpl<ClosedCaptionRuleParameters>(
        this as ClosedCaptionRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClosedCaptionRuleParameters &&
            const DeepCollectionEquality().equals(
              other.harmLabels,
              harmLabels,
            ) &&
            const DeepCollectionEquality().equals(
              other.llmHarmLabels,
              llmHarmLabels,
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
    const DeepCollectionEquality().hash(llmHarmLabels),
    severity,
    threshold,
    timeWindow,
  );

  @override
  String toString() {
    return 'ClosedCaptionRuleParameters(harmLabels: $harmLabels, llmHarmLabels: $llmHarmLabels, severity: $severity, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $ClosedCaptionRuleParametersCopyWith<$Res> {
  factory $ClosedCaptionRuleParametersCopyWith(
    ClosedCaptionRuleParameters value,
    $Res Function(ClosedCaptionRuleParameters) _then,
  ) = _$ClosedCaptionRuleParametersCopyWithImpl;
  @useResult
  $Res call({
    List<String>? harmLabels,
    Map<String, String>? llmHarmLabels,
    String? severity,
    int? threshold,
    String? timeWindow,
  });
}

/// @nodoc
class _$ClosedCaptionRuleParametersCopyWithImpl<$Res>
    implements $ClosedCaptionRuleParametersCopyWith<$Res> {
  _$ClosedCaptionRuleParametersCopyWithImpl(this._self, this._then);

  final ClosedCaptionRuleParameters _self;
  final $Res Function(ClosedCaptionRuleParameters) _then;

  /// Create a copy of ClosedCaptionRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? harmLabels = freezed,
    Object? llmHarmLabels = freezed,
    Object? severity = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      ClosedCaptionRuleParameters(
        harmLabels: freezed == harmLabels
            ? _self.harmLabels
            : harmLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        llmHarmLabels: freezed == llmHarmLabels
            ? _self.llmHarmLabels
            : llmHarmLabels // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
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
