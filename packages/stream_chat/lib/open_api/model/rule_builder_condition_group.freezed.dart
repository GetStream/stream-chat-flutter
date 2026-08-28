// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule_builder_condition_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RuleBuilderConditionGroup {
  List<RuleBuilderCondition>? get conditions;
  String? get logic;

  /// Create a copy of RuleBuilderConditionGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuleBuilderConditionGroupCopyWith<RuleBuilderConditionGroup> get copyWith =>
      _$RuleBuilderConditionGroupCopyWithImpl<RuleBuilderConditionGroup>(
        this as RuleBuilderConditionGroup,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuleBuilderConditionGroup &&
            const DeepCollectionEquality().equals(
              other.conditions,
              conditions,
            ) &&
            (identical(other.logic, logic) || other.logic == logic));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(conditions),
    logic,
  );

  @override
  String toString() {
    return 'RuleBuilderConditionGroup(conditions: $conditions, logic: $logic)';
  }
}

/// @nodoc
abstract mixin class $RuleBuilderConditionGroupCopyWith<$Res> {
  factory $RuleBuilderConditionGroupCopyWith(
    RuleBuilderConditionGroup value,
    $Res Function(RuleBuilderConditionGroup) _then,
  ) = _$RuleBuilderConditionGroupCopyWithImpl;
  @useResult
  $Res call({List<RuleBuilderCondition>? conditions, String? logic});
}

/// @nodoc
class _$RuleBuilderConditionGroupCopyWithImpl<$Res>
    implements $RuleBuilderConditionGroupCopyWith<$Res> {
  _$RuleBuilderConditionGroupCopyWithImpl(this._self, this._then);

  final RuleBuilderConditionGroup _self;
  final $Res Function(RuleBuilderConditionGroup) _then;

  /// Create a copy of RuleBuilderConditionGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? conditions = freezed, Object? logic = freezed}) {
    return _then(
      RuleBuilderConditionGroup(
        conditions: freezed == conditions
            ? _self.conditions
            : conditions // ignore: cast_nullable_to_non_nullable
                  as List<RuleBuilderCondition>?,
        logic: freezed == logic
            ? _self.logic
            : logic // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
