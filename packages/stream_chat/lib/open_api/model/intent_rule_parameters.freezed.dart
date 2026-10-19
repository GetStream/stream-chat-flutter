// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'intent_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntentRuleParameters {
  int? get threshold;
  String get topic;

  /// Create a copy of IntentRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IntentRuleParametersCopyWith<IntentRuleParameters> get copyWith =>
      _$IntentRuleParametersCopyWithImpl<IntentRuleParameters>(
        this as IntentRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IntentRuleParameters &&
            (identical(other.threshold, threshold) || other.threshold == threshold) &&
            (identical(other.topic, topic) || other.topic == topic));
  }

  @override
  int get hashCode => Object.hash(runtimeType, threshold, topic);

  @override
  String toString() {
    return 'IntentRuleParameters(threshold: $threshold, topic: $topic)';
  }
}

/// @nodoc
abstract mixin class $IntentRuleParametersCopyWith<$Res> {
  factory $IntentRuleParametersCopyWith(
    IntentRuleParameters value,
    $Res Function(IntentRuleParameters) _then,
  ) = _$IntentRuleParametersCopyWithImpl;
  @useResult
  $Res call({int? threshold, String topic});
}

/// @nodoc
class _$IntentRuleParametersCopyWithImpl<$Res> implements $IntentRuleParametersCopyWith<$Res> {
  _$IntentRuleParametersCopyWithImpl(this._self, this._then);

  final IntentRuleParameters _self;
  final $Res Function(IntentRuleParameters) _then;

  /// Create a copy of IntentRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? threshold = freezed, Object? topic = null}) {
    return _then(
      IntentRuleParameters(
        threshold: freezed == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int?,
        topic: null == topic
            ? _self.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
