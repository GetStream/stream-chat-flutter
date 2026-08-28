// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'automod_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AutomodRule {
  AutomodRuleAction get action;
  String get label;
  double get threshold;

  /// Create a copy of AutomodRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AutomodRuleCopyWith<AutomodRule> get copyWith =>
      _$AutomodRuleCopyWithImpl<AutomodRule>(this as AutomodRule, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AutomodRule &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold));
  }

  @override
  int get hashCode => Object.hash(runtimeType, action, label, threshold);

  @override
  String toString() {
    return 'AutomodRule(action: $action, label: $label, threshold: $threshold)';
  }
}

/// @nodoc
abstract mixin class $AutomodRuleCopyWith<$Res> {
  factory $AutomodRuleCopyWith(
    AutomodRule value,
    $Res Function(AutomodRule) _then,
  ) = _$AutomodRuleCopyWithImpl;
  @useResult
  $Res call({AutomodRuleAction action, String label, double threshold});
}

/// @nodoc
class _$AutomodRuleCopyWithImpl<$Res> implements $AutomodRuleCopyWith<$Res> {
  _$AutomodRuleCopyWithImpl(this._self, this._then);

  final AutomodRule _self;
  final $Res Function(AutomodRule) _then;

  /// Create a copy of AutomodRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? label = null,
    Object? threshold = null,
  }) {
    return _then(
      AutomodRule(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as AutomodRuleAction,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        threshold: null == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
