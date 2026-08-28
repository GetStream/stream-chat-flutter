// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flood_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FloodConfig {
  List<String>? get allowlist;
  FloodIdenticalConfig? get identical_;
  FloodSimilarConfig? get similar;

  /// Create a copy of FloodConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FloodConfigCopyWith<FloodConfig> get copyWith =>
      _$FloodConfigCopyWithImpl<FloodConfig>(this as FloodConfig, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FloodConfig &&
            const DeepCollectionEquality().equals(other.allowlist, allowlist) &&
            (identical(other.identical_, identical_) ||
                other.identical_ == identical_) &&
            (identical(other.similar, similar) || other.similar == similar));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(allowlist),
    identical_,
    similar,
  );

  @override
  String toString() {
    return 'FloodConfig(allowlist: $allowlist, identical_: $identical_, similar: $similar)';
  }
}

/// @nodoc
abstract mixin class $FloodConfigCopyWith<$Res> {
  factory $FloodConfigCopyWith(
    FloodConfig value,
    $Res Function(FloodConfig) _then,
  ) = _$FloodConfigCopyWithImpl;
  @useResult
  $Res call({
    List<String>? allowlist,
    FloodIdenticalConfig? identical_,
    FloodSimilarConfig? similar,
  });
}

/// @nodoc
class _$FloodConfigCopyWithImpl<$Res> implements $FloodConfigCopyWith<$Res> {
  _$FloodConfigCopyWithImpl(this._self, this._then);

  final FloodConfig _self;
  final $Res Function(FloodConfig) _then;

  /// Create a copy of FloodConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowlist = freezed,
    Object? identical_ = freezed,
    Object? similar = freezed,
  }) {
    return _then(
      FloodConfig(
        allowlist: freezed == allowlist
            ? _self.allowlist
            : allowlist // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        identical_: freezed == identical_
            ? _self.identical_
            : identical_ // ignore: cast_nullable_to_non_nullable
                  as FloodIdenticalConfig?,
        similar: freezed == similar
            ? _self.similar
            : similar // ignore: cast_nullable_to_non_nullable
                  as FloodSimilarConfig?,
      ),
    );
  }
}
