// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'automod_semantic_filters_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AutomodSemanticFiltersRule {
  AutomodSemanticFiltersRuleAction get action;
  String get name;
  double get threshold;

  /// Create a copy of AutomodSemanticFiltersRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AutomodSemanticFiltersRuleCopyWith<AutomodSemanticFiltersRule>
  get copyWith =>
      _$AutomodSemanticFiltersRuleCopyWithImpl<AutomodSemanticFiltersRule>(
        this as AutomodSemanticFiltersRule,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AutomodSemanticFiltersRule &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold));
  }

  @override
  int get hashCode => Object.hash(runtimeType, action, name, threshold);

  @override
  String toString() {
    return 'AutomodSemanticFiltersRule(action: $action, name: $name, threshold: $threshold)';
  }
}

/// @nodoc
abstract mixin class $AutomodSemanticFiltersRuleCopyWith<$Res> {
  factory $AutomodSemanticFiltersRuleCopyWith(
    AutomodSemanticFiltersRule value,
    $Res Function(AutomodSemanticFiltersRule) _then,
  ) = _$AutomodSemanticFiltersRuleCopyWithImpl;
  @useResult
  $Res call({
    AutomodSemanticFiltersRuleAction action,
    String name,
    double threshold,
  });
}

/// @nodoc
class _$AutomodSemanticFiltersRuleCopyWithImpl<$Res>
    implements $AutomodSemanticFiltersRuleCopyWith<$Res> {
  _$AutomodSemanticFiltersRuleCopyWithImpl(this._self, this._then);

  final AutomodSemanticFiltersRule _self;
  final $Res Function(AutomodSemanticFiltersRule) _then;

  /// Create a copy of AutomodSemanticFiltersRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? name = null,
    Object? threshold = null,
  }) {
    return _then(
      AutomodSemanticFiltersRule(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as AutomodSemanticFiltersRuleAction,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        threshold: null == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
