// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_list_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockListConfig {
  bool? get async;
  bool get enabled;
  bool? get matchSubstring;
  List<BlockListRule> get rules;

  /// Create a copy of BlockListConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockListConfigCopyWith<BlockListConfig> get copyWith =>
      _$BlockListConfigCopyWithImpl<BlockListConfig>(
        this as BlockListConfig,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockListConfig &&
            (identical(other.async, async) || other.async == async) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.matchSubstring, matchSubstring) ||
                other.matchSubstring == matchSubstring) &&
            const DeepCollectionEquality().equals(other.rules, rules));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    async,
    enabled,
    matchSubstring,
    const DeepCollectionEquality().hash(rules),
  );

  @override
  String toString() {
    return 'BlockListConfig(async: $async, enabled: $enabled, matchSubstring: $matchSubstring, rules: $rules)';
  }
}

/// @nodoc
abstract mixin class $BlockListConfigCopyWith<$Res> {
  factory $BlockListConfigCopyWith(
    BlockListConfig value,
    $Res Function(BlockListConfig) _then,
  ) = _$BlockListConfigCopyWithImpl;
  @useResult
  $Res call({
    bool? async,
    bool enabled,
    bool? matchSubstring,
    List<BlockListRule> rules,
  });
}

/// @nodoc
class _$BlockListConfigCopyWithImpl<$Res>
    implements $BlockListConfigCopyWith<$Res> {
  _$BlockListConfigCopyWithImpl(this._self, this._then);

  final BlockListConfig _self;
  final $Res Function(BlockListConfig) _then;

  /// Create a copy of BlockListConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? async = freezed,
    Object? enabled = null,
    Object? matchSubstring = freezed,
    Object? rules = null,
  }) {
    return _then(
      BlockListConfig(
        async: freezed == async
            ? _self.async
            : async // ignore: cast_nullable_to_non_nullable
                  as bool?,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        matchSubstring: freezed == matchSubstring
            ? _self.matchSubstring
            : matchSubstring // ignore: cast_nullable_to_non_nullable
                  as bool?,
        rules: null == rules
            ? _self.rules
            : rules // ignore: cast_nullable_to_non_nullable
                  as List<BlockListRule>,
      ),
    );
  }
}
