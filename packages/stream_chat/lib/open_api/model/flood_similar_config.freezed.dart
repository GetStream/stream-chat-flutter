// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flood_similar_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FloodSimilarConfig {
  String get action;
  bool get enabled;
  int get similarityDistance;
  int get threshold;
  String get timeWindow;

  /// Create a copy of FloodSimilarConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FloodSimilarConfigCopyWith<FloodSimilarConfig> get copyWith =>
      _$FloodSimilarConfigCopyWithImpl<FloodSimilarConfig>(
        this as FloodSimilarConfig,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FloodSimilarConfig &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
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
    action,
    enabled,
    similarityDistance,
    threshold,
    timeWindow,
  );

  @override
  String toString() {
    return 'FloodSimilarConfig(action: $action, enabled: $enabled, similarityDistance: $similarityDistance, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $FloodSimilarConfigCopyWith<$Res> {
  factory $FloodSimilarConfigCopyWith(
    FloodSimilarConfig value,
    $Res Function(FloodSimilarConfig) _then,
  ) = _$FloodSimilarConfigCopyWithImpl;
  @useResult
  $Res call({
    String action,
    bool enabled,
    int similarityDistance,
    int threshold,
    String timeWindow,
  });
}

/// @nodoc
class _$FloodSimilarConfigCopyWithImpl<$Res>
    implements $FloodSimilarConfigCopyWith<$Res> {
  _$FloodSimilarConfigCopyWithImpl(this._self, this._then);

  final FloodSimilarConfig _self;
  final $Res Function(FloodSimilarConfig) _then;

  /// Create a copy of FloodSimilarConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? enabled = null,
    Object? similarityDistance = null,
    Object? threshold = null,
    Object? timeWindow = null,
  }) {
    return _then(
      FloodSimilarConfig(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        similarityDistance: null == similarityDistance
            ? _self.similarityDistance
            : similarityDistance // ignore: cast_nullable_to_non_nullable
                  as int,
        threshold: null == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int,
        timeWindow: null == timeWindow
            ? _self.timeWindow
            : timeWindow // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
