// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flood_identical_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FloodIdenticalRuleParameters {
  List<String>? get allowlist;
  int? get minTextLength;
  int? get threshold;
  String? get timeWindow;
  bool? get trackAcrossUsers;

  /// Create a copy of FloodIdenticalRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FloodIdenticalRuleParametersCopyWith<FloodIdenticalRuleParameters> get copyWith =>
      _$FloodIdenticalRuleParametersCopyWithImpl<FloodIdenticalRuleParameters>(
        this as FloodIdenticalRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FloodIdenticalRuleParameters &&
            const DeepCollectionEquality().equals(other.allowlist, allowlist) &&
            (identical(other.minTextLength, minTextLength) || other.minTextLength == minTextLength) &&
            (identical(other.threshold, threshold) || other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) || other.timeWindow == timeWindow) &&
            (identical(other.trackAcrossUsers, trackAcrossUsers) || other.trackAcrossUsers == trackAcrossUsers));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(allowlist),
    minTextLength,
    threshold,
    timeWindow,
    trackAcrossUsers,
  );

  @override
  String toString() {
    return 'FloodIdenticalRuleParameters(allowlist: $allowlist, minTextLength: $minTextLength, threshold: $threshold, timeWindow: $timeWindow, trackAcrossUsers: $trackAcrossUsers)';
  }
}

/// @nodoc
abstract mixin class $FloodIdenticalRuleParametersCopyWith<$Res> {
  factory $FloodIdenticalRuleParametersCopyWith(
    FloodIdenticalRuleParameters value,
    $Res Function(FloodIdenticalRuleParameters) _then,
  ) = _$FloodIdenticalRuleParametersCopyWithImpl;
  @useResult
  $Res call({
    List<String>? allowlist,
    int? minTextLength,
    int? threshold,
    String? timeWindow,
    bool? trackAcrossUsers,
  });
}

/// @nodoc
class _$FloodIdenticalRuleParametersCopyWithImpl<$Res> implements $FloodIdenticalRuleParametersCopyWith<$Res> {
  _$FloodIdenticalRuleParametersCopyWithImpl(this._self, this._then);

  final FloodIdenticalRuleParameters _self;
  final $Res Function(FloodIdenticalRuleParameters) _then;

  /// Create a copy of FloodIdenticalRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowlist = freezed,
    Object? minTextLength = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
    Object? trackAcrossUsers = freezed,
  }) {
    return _then(
      FloodIdenticalRuleParameters(
        allowlist: freezed == allowlist
            ? _self.allowlist
            : allowlist // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        minTextLength: freezed == minTextLength
            ? _self.minTextLength
            : minTextLength // ignore: cast_nullable_to_non_nullable
                  as int?,
        threshold: freezed == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int?,
        timeWindow: freezed == timeWindow
            ? _self.timeWindow
            : timeWindow // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackAcrossUsers: freezed == trackAcrossUsers
            ? _self.trackAcrossUsers
            : trackAcrossUsers // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
