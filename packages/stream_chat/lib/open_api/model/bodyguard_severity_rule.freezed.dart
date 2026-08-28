// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bodyguard_severity_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BodyguardSeverityRule {
  BodyguardSeverityRuleAction get action;
  BodyguardSeverityRuleSeverity get severity;

  /// Create a copy of BodyguardSeverityRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BodyguardSeverityRuleCopyWith<BodyguardSeverityRule> get copyWith =>
      _$BodyguardSeverityRuleCopyWithImpl<BodyguardSeverityRule>(
        this as BodyguardSeverityRule,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BodyguardSeverityRule &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.severity, severity) ||
                other.severity == severity));
  }

  @override
  int get hashCode => Object.hash(runtimeType, action, severity);

  @override
  String toString() {
    return 'BodyguardSeverityRule(action: $action, severity: $severity)';
  }
}

/// @nodoc
abstract mixin class $BodyguardSeverityRuleCopyWith<$Res> {
  factory $BodyguardSeverityRuleCopyWith(
    BodyguardSeverityRule value,
    $Res Function(BodyguardSeverityRule) _then,
  ) = _$BodyguardSeverityRuleCopyWithImpl;
  @useResult
  $Res call({
    BodyguardSeverityRuleAction action,
    BodyguardSeverityRuleSeverity severity,
  });
}

/// @nodoc
class _$BodyguardSeverityRuleCopyWithImpl<$Res>
    implements $BodyguardSeverityRuleCopyWith<$Res> {
  _$BodyguardSeverityRuleCopyWithImpl(this._self, this._then);

  final BodyguardSeverityRule _self;
  final $Res Function(BodyguardSeverityRule) _then;

  /// Create a copy of BodyguardSeverityRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? action = null, Object? severity = null}) {
    return _then(
      BodyguardSeverityRule(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as BodyguardSeverityRuleAction,
        severity: null == severity
            ? _self.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as BodyguardSeverityRuleSeverity,
      ),
    );
  }
}
