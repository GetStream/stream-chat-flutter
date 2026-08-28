// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'velocity_filter_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VelocityFilterConfig {
  bool get advancedFilters;
  bool? get async;
  bool get cascadingActions;
  int get cidsPerUser;
  bool get enabled;
  bool get firstMessageOnly;
  List<VelocityFilterConfigRule> get rules;

  /// Create a copy of VelocityFilterConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VelocityFilterConfigCopyWith<VelocityFilterConfig> get copyWith =>
      _$VelocityFilterConfigCopyWithImpl<VelocityFilterConfig>(
        this as VelocityFilterConfig,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VelocityFilterConfig &&
            (identical(other.advancedFilters, advancedFilters) ||
                other.advancedFilters == advancedFilters) &&
            (identical(other.async, async) || other.async == async) &&
            (identical(other.cascadingActions, cascadingActions) ||
                other.cascadingActions == cascadingActions) &&
            (identical(other.cidsPerUser, cidsPerUser) ||
                other.cidsPerUser == cidsPerUser) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.firstMessageOnly, firstMessageOnly) ||
                other.firstMessageOnly == firstMessageOnly) &&
            const DeepCollectionEquality().equals(other.rules, rules));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    advancedFilters,
    async,
    cascadingActions,
    cidsPerUser,
    enabled,
    firstMessageOnly,
    const DeepCollectionEquality().hash(rules),
  );

  @override
  String toString() {
    return 'VelocityFilterConfig(advancedFilters: $advancedFilters, async: $async, cascadingActions: $cascadingActions, cidsPerUser: $cidsPerUser, enabled: $enabled, firstMessageOnly: $firstMessageOnly, rules: $rules)';
  }
}

/// @nodoc
abstract mixin class $VelocityFilterConfigCopyWith<$Res> {
  factory $VelocityFilterConfigCopyWith(
    VelocityFilterConfig value,
    $Res Function(VelocityFilterConfig) _then,
  ) = _$VelocityFilterConfigCopyWithImpl;
  @useResult
  $Res call({
    bool advancedFilters,
    bool? async,
    bool cascadingActions,
    int cidsPerUser,
    bool enabled,
    bool firstMessageOnly,
    List<VelocityFilterConfigRule> rules,
  });
}

/// @nodoc
class _$VelocityFilterConfigCopyWithImpl<$Res>
    implements $VelocityFilterConfigCopyWith<$Res> {
  _$VelocityFilterConfigCopyWithImpl(this._self, this._then);

  final VelocityFilterConfig _self;
  final $Res Function(VelocityFilterConfig) _then;

  /// Create a copy of VelocityFilterConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? advancedFilters = null,
    Object? async = freezed,
    Object? cascadingActions = null,
    Object? cidsPerUser = null,
    Object? enabled = null,
    Object? firstMessageOnly = null,
    Object? rules = null,
  }) {
    return _then(
      VelocityFilterConfig(
        advancedFilters: null == advancedFilters
            ? _self.advancedFilters
            : advancedFilters // ignore: cast_nullable_to_non_nullable
                  as bool,
        async: freezed == async
            ? _self.async
            : async // ignore: cast_nullable_to_non_nullable
                  as bool?,
        cascadingActions: null == cascadingActions
            ? _self.cascadingActions
            : cascadingActions // ignore: cast_nullable_to_non_nullable
                  as bool,
        cidsPerUser: null == cidsPerUser
            ? _self.cidsPerUser
            : cidsPerUser // ignore: cast_nullable_to_non_nullable
                  as int,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        firstMessageOnly: null == firstMessageOnly
            ? _self.firstMessageOnly
            : firstMessageOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
        rules: null == rules
            ? _self.rules
            : rules // ignore: cast_nullable_to_non_nullable
                  as List<VelocityFilterConfigRule>,
      ),
    );
  }
}
