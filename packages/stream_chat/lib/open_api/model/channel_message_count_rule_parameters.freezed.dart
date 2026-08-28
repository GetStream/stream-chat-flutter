// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_message_count_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelMessageCountRuleParameters {
  String? get operator;
  int? get threshold;

  /// Create a copy of ChannelMessageCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelMessageCountRuleParametersCopyWith<ChannelMessageCountRuleParameters>
  get copyWith =>
      _$ChannelMessageCountRuleParametersCopyWithImpl<
        ChannelMessageCountRuleParameters
      >(this as ChannelMessageCountRuleParameters, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelMessageCountRuleParameters &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operator, threshold);

  @override
  String toString() {
    return 'ChannelMessageCountRuleParameters(operator: $operator, threshold: $threshold)';
  }
}

/// @nodoc
abstract mixin class $ChannelMessageCountRuleParametersCopyWith<$Res> {
  factory $ChannelMessageCountRuleParametersCopyWith(
    ChannelMessageCountRuleParameters value,
    $Res Function(ChannelMessageCountRuleParameters) _then,
  ) = _$ChannelMessageCountRuleParametersCopyWithImpl;
  @useResult
  $Res call({String? operator, int? threshold});
}

/// @nodoc
class _$ChannelMessageCountRuleParametersCopyWithImpl<$Res>
    implements $ChannelMessageCountRuleParametersCopyWith<$Res> {
  _$ChannelMessageCountRuleParametersCopyWithImpl(this._self, this._then);

  final ChannelMessageCountRuleParameters _self;
  final $Res Function(ChannelMessageCountRuleParameters) _then;

  /// Create a copy of ChannelMessageCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? operator = freezed, Object? threshold = freezed}) {
    return _then(
      ChannelMessageCountRuleParameters(
        operator: freezed == operator
            ? _self.operator
            : operator // ignore: cast_nullable_to_non_nullable
                  as String?,
        threshold: freezed == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
