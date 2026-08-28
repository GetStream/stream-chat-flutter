// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'keyframe_ocr_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KeyframeOCRRuleParameters {
  List<String>? get harmLabels;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of KeyframeOCRRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KeyframeOCRRuleParametersCopyWith<KeyframeOCRRuleParameters> get copyWith =>
      _$KeyframeOCRRuleParametersCopyWithImpl<KeyframeOCRRuleParameters>(
        this as KeyframeOCRRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KeyframeOCRRuleParameters &&
            const DeepCollectionEquality().equals(
              other.harmLabels,
              harmLabels,
            ) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) ||
                other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(harmLabels),
    threshold,
    timeWindow,
  );

  @override
  String toString() {
    return 'KeyframeOCRRuleParameters(harmLabels: $harmLabels, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $KeyframeOCRRuleParametersCopyWith<$Res> {
  factory $KeyframeOCRRuleParametersCopyWith(
    KeyframeOCRRuleParameters value,
    $Res Function(KeyframeOCRRuleParameters) _then,
  ) = _$KeyframeOCRRuleParametersCopyWithImpl;
  @useResult
  $Res call({List<String>? harmLabels, int? threshold, String? timeWindow});
}

/// @nodoc
class _$KeyframeOCRRuleParametersCopyWithImpl<$Res>
    implements $KeyframeOCRRuleParametersCopyWith<$Res> {
  _$KeyframeOCRRuleParametersCopyWithImpl(this._self, this._then);

  final KeyframeOCRRuleParameters _self;
  final $Res Function(KeyframeOCRRuleParameters) _then;

  /// Create a copy of KeyframeOCRRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? harmLabels = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      KeyframeOCRRuleParameters(
        harmLabels: freezed == harmLabels
            ? _self.harmLabels
            : harmLabels // ignore: cast_nullable_to_non_nullable
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
