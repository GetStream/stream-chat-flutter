// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ocr_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OCRRule {
  OCRRuleAction get action;
  String get label;

  /// Create a copy of OCRRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OCRRuleCopyWith<OCRRule> get copyWith =>
      _$OCRRuleCopyWithImpl<OCRRule>(this as OCRRule, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OCRRule &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, action, label);

  @override
  String toString() {
    return 'OCRRule(action: $action, label: $label)';
  }
}

/// @nodoc
abstract mixin class $OCRRuleCopyWith<$Res> {
  factory $OCRRuleCopyWith(OCRRule value, $Res Function(OCRRule) _then) =
      _$OCRRuleCopyWithImpl;
  @useResult
  $Res call({OCRRuleAction action, String label});
}

/// @nodoc
class _$OCRRuleCopyWithImpl<$Res> implements $OCRRuleCopyWith<$Res> {
  _$OCRRuleCopyWithImpl(this._self, this._then);

  final OCRRule _self;
  final $Res Function(OCRRule) _then;

  /// Create a copy of OCRRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? action = null, Object? label = null}) {
    return _then(
      OCRRule(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as OCRRuleAction,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
