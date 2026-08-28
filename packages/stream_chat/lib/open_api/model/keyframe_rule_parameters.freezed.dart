// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keyframe_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KeyframeRuleParameters {
  List<String>? get harmLabels;
  double? get minConfidence;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of KeyframeRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KeyframeRuleParametersCopyWith<KeyframeRuleParameters> get copyWith =>
      _$KeyframeRuleParametersCopyWithImpl<KeyframeRuleParameters>(
        this as KeyframeRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KeyframeRuleParameters &&
            const DeepCollectionEquality().equals(
              other.harmLabels,
              harmLabels,
            ) &&
            (identical(other.minConfidence, minConfidence) ||
                other.minConfidence == minConfidence) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) ||
                other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(harmLabels),
    minConfidence,
    threshold,
    timeWindow,
  );

  @override
  String toString() {
    return 'KeyframeRuleParameters(harmLabels: $harmLabels, minConfidence: $minConfidence, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $KeyframeRuleParametersCopyWith<$Res> {
  factory $KeyframeRuleParametersCopyWith(
    KeyframeRuleParameters value,
    $Res Function(KeyframeRuleParameters) _then,
  ) = _$KeyframeRuleParametersCopyWithImpl;
  @useResult
  $Res call({
    List<String>? harmLabels,
    double? minConfidence,
    int? threshold,
    String? timeWindow,
  });
}

/// @nodoc
class _$KeyframeRuleParametersCopyWithImpl<$Res>
    implements $KeyframeRuleParametersCopyWith<$Res> {
  _$KeyframeRuleParametersCopyWithImpl(this._self, this._then);

  final KeyframeRuleParameters _self;
  final $Res Function(KeyframeRuleParameters) _then;

  /// Create a copy of KeyframeRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? harmLabels = freezed,
    Object? minConfidence = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      KeyframeRuleParameters(
        harmLabels: freezed == harmLabels
            ? _self.harmLabels
            : harmLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        minConfidence: freezed == minConfidence
            ? _self.minConfidence
            : minConfidence // ignore: cast_nullable_to_non_nullable
                  as double?,
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
