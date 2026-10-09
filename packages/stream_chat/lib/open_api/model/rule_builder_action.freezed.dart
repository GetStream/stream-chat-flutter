// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule_builder_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RuleBuilderAction {
  BanOptions? get banOptions;
  CallActionOptions? get callOptions;
  FlagUserOptions? get flagUserOptions;
  String? get reason;
  bool? get skipInbox;
  RuleBuilderActionType? get type;

  /// Create a copy of RuleBuilderAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RuleBuilderActionCopyWith<RuleBuilderAction> get copyWith => _$RuleBuilderActionCopyWithImpl<RuleBuilderAction>(
    this as RuleBuilderAction,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RuleBuilderAction &&
            (identical(other.banOptions, banOptions) || other.banOptions == banOptions) &&
            (identical(other.callOptions, callOptions) || other.callOptions == callOptions) &&
            (identical(other.flagUserOptions, flagUserOptions) || other.flagUserOptions == flagUserOptions) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.skipInbox, skipInbox) || other.skipInbox == skipInbox) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    banOptions,
    callOptions,
    flagUserOptions,
    reason,
    skipInbox,
    type,
  );

  @override
  String toString() {
    return 'RuleBuilderAction(banOptions: $banOptions, callOptions: $callOptions, flagUserOptions: $flagUserOptions, reason: $reason, skipInbox: $skipInbox, type: $type)';
  }
}

/// @nodoc
abstract mixin class $RuleBuilderActionCopyWith<$Res> {
  factory $RuleBuilderActionCopyWith(
    RuleBuilderAction value,
    $Res Function(RuleBuilderAction) _then,
  ) = _$RuleBuilderActionCopyWithImpl;
  @useResult
  $Res call({
    BanOptions? banOptions,
    CallActionOptions? callOptions,
    FlagUserOptions? flagUserOptions,
    String? reason,
    bool? skipInbox,
    RuleBuilderActionType? type,
  });
}

/// @nodoc
class _$RuleBuilderActionCopyWithImpl<$Res> implements $RuleBuilderActionCopyWith<$Res> {
  _$RuleBuilderActionCopyWithImpl(this._self, this._then);

  final RuleBuilderAction _self;
  final $Res Function(RuleBuilderAction) _then;

  /// Create a copy of RuleBuilderAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? banOptions = freezed,
    Object? callOptions = freezed,
    Object? flagUserOptions = freezed,
    Object? reason = freezed,
    Object? skipInbox = freezed,
    Object? type = freezed,
  }) {
    return _then(
      RuleBuilderAction(
        banOptions: freezed == banOptions
            ? _self.banOptions
            : banOptions // ignore: cast_nullable_to_non_nullable
                  as BanOptions?,
        callOptions: freezed == callOptions
            ? _self.callOptions
            : callOptions // ignore: cast_nullable_to_non_nullable
                  as CallActionOptions?,
        flagUserOptions: freezed == flagUserOptions
            ? _self.flagUserOptions
            : flagUserOptions // ignore: cast_nullable_to_non_nullable
                  as FlagUserOptions?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        skipInbox: freezed == skipInbox
            ? _self.skipInbox
            : skipInbox // ignore: cast_nullable_to_non_nullable
                  as bool?,
        type: freezed == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RuleBuilderActionType?,
      ),
    );
  }
}
