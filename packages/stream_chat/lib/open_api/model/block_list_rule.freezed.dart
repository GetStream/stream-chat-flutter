// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_list_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockListRule {
  BlockListRuleAction get action;
  String get name;
  String get team;

  /// Create a copy of BlockListRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockListRuleCopyWith<BlockListRule> get copyWith =>
      _$BlockListRuleCopyWithImpl<BlockListRule>(
        this as BlockListRule,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockListRule &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.team, team) || other.team == team));
  }

  @override
  int get hashCode => Object.hash(runtimeType, action, name, team);

  @override
  String toString() {
    return 'BlockListRule(action: $action, name: $name, team: $team)';
  }
}

/// @nodoc
abstract mixin class $BlockListRuleCopyWith<$Res> {
  factory $BlockListRuleCopyWith(
    BlockListRule value,
    $Res Function(BlockListRule) _then,
  ) = _$BlockListRuleCopyWithImpl;
  @useResult
  $Res call({BlockListRuleAction action, String name, String team});
}

/// @nodoc
class _$BlockListRuleCopyWithImpl<$Res>
    implements $BlockListRuleCopyWith<$Res> {
  _$BlockListRuleCopyWithImpl(this._self, this._then);

  final BlockListRule _self;
  final $Res Function(BlockListRule) _then;

  /// Create a copy of BlockListRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? action = null, Object? name = null, Object? team = null}) {
    return _then(
      BlockListRule(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as BlockListRuleAction,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        team: null == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
