// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bodyguard_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BodyguardRule {
  BodyguardRuleAction get action;
  String get label;
  List<BodyguardSeverityRule> get severityRules;

  /// Create a copy of BodyguardRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BodyguardRuleCopyWith<BodyguardRule> get copyWith =>
      _$BodyguardRuleCopyWithImpl<BodyguardRule>(
        this as BodyguardRule,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BodyguardRule &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(
              other.severityRules,
              severityRules,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    label,
    const DeepCollectionEquality().hash(severityRules),
  );

  @override
  String toString() {
    return 'BodyguardRule(action: $action, label: $label, severityRules: $severityRules)';
  }
}

/// @nodoc
abstract mixin class $BodyguardRuleCopyWith<$Res> {
  factory $BodyguardRuleCopyWith(
    BodyguardRule value,
    $Res Function(BodyguardRule) _then,
  ) = _$BodyguardRuleCopyWithImpl;
  @useResult
  $Res call({
    BodyguardRuleAction action,
    String label,
    List<BodyguardSeverityRule> severityRules,
  });
}

/// @nodoc
class _$BodyguardRuleCopyWithImpl<$Res>
    implements $BodyguardRuleCopyWith<$Res> {
  _$BodyguardRuleCopyWithImpl(this._self, this._then);

  final BodyguardRule _self;
  final $Res Function(BodyguardRule) _then;

  /// Create a copy of BodyguardRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? label = null,
    Object? severityRules = null,
  }) {
    return _then(
      BodyguardRule(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as BodyguardRuleAction,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        severityRules: null == severityRules
            ? _self.severityRules
            : severityRules // ignore: cast_nullable_to_non_nullable
                  as List<BodyguardSeverityRule>,
      ),
    );
  }
}
