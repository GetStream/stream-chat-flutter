// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flood_similar_rule_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FloodSimilarRuleParameters {
  List<String>? get allowlist;
  int? get similarityDistance;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of FloodSimilarRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FloodSimilarRuleParametersCopyWith<FloodSimilarRuleParameters>
  get copyWith =>
      _$FloodSimilarRuleParametersCopyWithImpl<FloodSimilarRuleParameters>(
        this as FloodSimilarRuleParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FloodSimilarRuleParameters &&
            const DeepCollectionEquality().equals(other.allowlist, allowlist) &&
            (identical(other.similarityDistance, similarityDistance) ||
                other.similarityDistance == similarityDistance) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) ||
                other.timeWindow == timeWindow));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(allowlist),
    similarityDistance,
    threshold,
    timeWindow,
  );

  @override
  String toString() {
    return 'FloodSimilarRuleParameters(allowlist: $allowlist, similarityDistance: $similarityDistance, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $FloodSimilarRuleParametersCopyWith<$Res> {
  factory $FloodSimilarRuleParametersCopyWith(
    FloodSimilarRuleParameters value,
    $Res Function(FloodSimilarRuleParameters) _then,
  ) = _$FloodSimilarRuleParametersCopyWithImpl;
  @useResult
  $Res call({
    List<String>? allowlist,
    int? similarityDistance,
    int? threshold,
    String? timeWindow,
  });
}

/// @nodoc
class _$FloodSimilarRuleParametersCopyWithImpl<$Res>
    implements $FloodSimilarRuleParametersCopyWith<$Res> {
  _$FloodSimilarRuleParametersCopyWithImpl(this._self, this._then);

  final FloodSimilarRuleParameters _self;
  final $Res Function(FloodSimilarRuleParameters) _then;

  /// Create a copy of FloodSimilarRuleParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowlist = freezed,
    Object? similarityDistance = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      FloodSimilarRuleParameters(
        allowlist: freezed == allowlist
            ? _self.allowlist
            : allowlist // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        similarityDistance: freezed == similarityDistance
            ? _self.similarityDistance
            : similarityDistance // ignore: cast_nullable_to_non_nullable
                  as int?,
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
