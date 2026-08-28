// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_rule_action_sequence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallRuleActionSequence {
  List<String>? get actions;
  CallActionOptions? get callOptions;
  int? get violationNumber;

  /// Create a copy of CallRuleActionSequence
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRuleActionSequenceCopyWith<CallRuleActionSequence> get copyWith =>
      _$CallRuleActionSequenceCopyWithImpl<CallRuleActionSequence>(
        this as CallRuleActionSequence,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRuleActionSequence &&
            const DeepCollectionEquality().equals(other.actions, actions) &&
            (identical(other.callOptions, callOptions) ||
                other.callOptions == callOptions) &&
            (identical(other.violationNumber, violationNumber) ||
                other.violationNumber == violationNumber));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(actions),
    callOptions,
    violationNumber,
  );

  @override
  String toString() {
    return 'CallRuleActionSequence(actions: $actions, callOptions: $callOptions, violationNumber: $violationNumber)';
  }
}

/// @nodoc
abstract mixin class $CallRuleActionSequenceCopyWith<$Res> {
  factory $CallRuleActionSequenceCopyWith(
    CallRuleActionSequence value,
    $Res Function(CallRuleActionSequence) _then,
  ) = _$CallRuleActionSequenceCopyWithImpl;
  @useResult
  $Res call({
    List<String>? actions,
    CallActionOptions? callOptions,
    int? violationNumber,
  });
}

/// @nodoc
class _$CallRuleActionSequenceCopyWithImpl<$Res>
    implements $CallRuleActionSequenceCopyWith<$Res> {
  _$CallRuleActionSequenceCopyWithImpl(this._self, this._then);

  final CallRuleActionSequence _self;
  final $Res Function(CallRuleActionSequence) _then;

  /// Create a copy of CallRuleActionSequence
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actions = freezed,
    Object? callOptions = freezed,
    Object? violationNumber = freezed,
  }) {
    return _then(
      CallRuleActionSequence(
        actions: freezed == actions
            ? _self.actions
            : actions // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        callOptions: freezed == callOptions
            ? _self.callOptions
            : callOptions // ignore: cast_nullable_to_non_nullable
                  as CallActionOptions?,
        violationNumber: freezed == violationNumber
            ? _self.violationNumber
            : violationNumber // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
