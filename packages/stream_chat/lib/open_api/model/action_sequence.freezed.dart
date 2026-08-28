// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_sequence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActionSequence {
  String get action;
  bool get blur;
  int get cooldownPeriod;
  int get threshold;
  int get timeWindow;
  bool get warning;
  String get warningText;

  /// Create a copy of ActionSequence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActionSequenceCopyWith<ActionSequence> get copyWith =>
      _$ActionSequenceCopyWithImpl<ActionSequence>(
        this as ActionSequence,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActionSequence &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.blur, blur) || other.blur == blur) &&
            (identical(other.cooldownPeriod, cooldownPeriod) ||
                other.cooldownPeriod == cooldownPeriod) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) ||
                other.timeWindow == timeWindow) &&
            (identical(other.warning, warning) || other.warning == warning) &&
            (identical(other.warningText, warningText) ||
                other.warningText == warningText));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    blur,
    cooldownPeriod,
    threshold,
    timeWindow,
    warning,
    warningText,
  );

  @override
  String toString() {
    return 'ActionSequence(action: $action, blur: $blur, cooldownPeriod: $cooldownPeriod, threshold: $threshold, timeWindow: $timeWindow, warning: $warning, warningText: $warningText)';
  }
}

/// @nodoc
abstract mixin class $ActionSequenceCopyWith<$Res> {
  factory $ActionSequenceCopyWith(
    ActionSequence value,
    $Res Function(ActionSequence) _then,
  ) = _$ActionSequenceCopyWithImpl;
  @useResult
  $Res call({
    String action,
    bool blur,
    int cooldownPeriod,
    int threshold,
    int timeWindow,
    bool warning,
    String warningText,
  });
}

/// @nodoc
class _$ActionSequenceCopyWithImpl<$Res>
    implements $ActionSequenceCopyWith<$Res> {
  _$ActionSequenceCopyWithImpl(this._self, this._then);

  final ActionSequence _self;
  final $Res Function(ActionSequence) _then;

  /// Create a copy of ActionSequence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? blur = null,
    Object? cooldownPeriod = null,
    Object? threshold = null,
    Object? timeWindow = null,
    Object? warning = null,
    Object? warningText = null,
  }) {
    return _then(
      ActionSequence(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        blur: null == blur
            ? _self.blur
            : blur // ignore: cast_nullable_to_non_nullable
                  as bool,
        cooldownPeriod: null == cooldownPeriod
            ? _self.cooldownPeriod
            : cooldownPeriod // ignore: cast_nullable_to_non_nullable
                  as int,
        threshold: null == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int,
        timeWindow: null == timeWindow
            ? _self.timeWindow
            : timeWindow // ignore: cast_nullable_to_non_nullable
                  as int,
        warning: null == warning
            ? _self.warning
            : warning // ignore: cast_nullable_to_non_nullable
                  as bool,
        warningText: null == warningText
            ? _self.warningText
            : warningText // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
