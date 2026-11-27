// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_reaction_count_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserReactionCountRuleParameters {
  String? get count;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of UserReactionCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserReactionCountRuleParametersCopyWith<UserReactionCountRuleParameters> get copyWith =>
      _$UserReactionCountRuleParametersCopyWithImpl<UserReactionCountRuleParameters>(
        this as UserReactionCountRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserReactionCountRuleParameters &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.threshold, threshold) || other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count, threshold, timeWindow);

  @override
  String toString() {
    return 'UserReactionCountRuleParameters(count: $count, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $UserReactionCountRuleParametersCopyWith<$Res> {
  factory $UserReactionCountRuleParametersCopyWith(
    UserReactionCountRuleParameters value,
    $Res Function(UserReactionCountRuleParameters) _then,
  ) = _$UserReactionCountRuleParametersCopyWithImpl;
  @useResult
  $Res call({String? count, int? threshold, String? timeWindow});
}

/// @nodoc
class _$UserReactionCountRuleParametersCopyWithImpl<$Res> implements $UserReactionCountRuleParametersCopyWith<$Res> {
  _$UserReactionCountRuleParametersCopyWithImpl(this._self, this._then);

  final UserReactionCountRuleParameters _self;
  final $Res Function(UserReactionCountRuleParameters) _then;

  /// Create a copy of UserReactionCountRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      UserReactionCountRuleParameters(
        count: freezed == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as String?,
        threshold: freezed == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int?,
        timeWindow: freezed == timeWindow
            ? _self.timeWindow
            : timeWindow // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
