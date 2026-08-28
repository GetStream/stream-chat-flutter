// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LLMRule {
  LLMRuleAction get action;
  String get description;
  String get label;
  List<BodyguardSeverityRule> get severityRules;

  /// Create a copy of LLMRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LLMRuleCopyWith<LLMRule> get copyWith =>
      _$LLMRuleCopyWithImpl<LLMRule>(this as LLMRule, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LLMRule &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.description, description) ||
                other.description == description) &&
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
    description,
    label,
    const DeepCollectionEquality().hash(severityRules),
  );

  @override
  String toString() {
    return 'LLMRule(action: $action, description: $description, label: $label, severityRules: $severityRules)';
  }
}

/// @nodoc
abstract mixin class $LLMRuleCopyWith<$Res> {
  factory $LLMRuleCopyWith(LLMRule value, $Res Function(LLMRule) _then) =
      _$LLMRuleCopyWithImpl;
  @useResult
  $Res call({
    LLMRuleAction action,
    String description,
    String label,
    List<BodyguardSeverityRule> severityRules,
  });
}

/// @nodoc
class _$LLMRuleCopyWithImpl<$Res> implements $LLMRuleCopyWith<$Res> {
  _$LLMRuleCopyWithImpl(this._self, this._then);

  final LLMRule _self;
  final $Res Function(LLMRule) _then;

  /// Create a copy of LLMRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? description = null,
    Object? label = null,
    Object? severityRules = null,
  }) {
    return _then(
      LLMRule(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as LLMRuleAction,
        description: null == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
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
