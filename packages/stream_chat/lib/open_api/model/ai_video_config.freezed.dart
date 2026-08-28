// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_video_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIVideoConfig {
  bool? get async;
  bool get enabled;
  List<AWSRekognitionRule> get rules;

  /// Create a copy of AIVideoConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIVideoConfigCopyWith<AIVideoConfig> get copyWith =>
      _$AIVideoConfigCopyWithImpl<AIVideoConfig>(
        this as AIVideoConfig,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIVideoConfig &&
            (identical(other.async, async) || other.async == async) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality().equals(other.rules, rules));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    async,
    enabled,
    const DeepCollectionEquality().hash(rules),
  );

  @override
  String toString() {
    return 'AIVideoConfig(async: $async, enabled: $enabled, rules: $rules)';
  }
}

/// @nodoc
abstract mixin class $AIVideoConfigCopyWith<$Res> {
  factory $AIVideoConfigCopyWith(
    AIVideoConfig value,
    $Res Function(AIVideoConfig) _then,
  ) = _$AIVideoConfigCopyWithImpl;
  @useResult
  $Res call({bool? async, bool enabled, List<AWSRekognitionRule> rules});
}

/// @nodoc
class _$AIVideoConfigCopyWithImpl<$Res>
    implements $AIVideoConfigCopyWith<$Res> {
  _$AIVideoConfigCopyWithImpl(this._self, this._then);

  final AIVideoConfig _self;
  final $Res Function(AIVideoConfig) _then;

  /// Create a copy of AIVideoConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? async = freezed,
    Object? enabled = null,
    Object? rules = null,
  }) {
    return _then(
      AIVideoConfig(
        async: freezed == async
            ? _self.async
            : async // ignore: cast_nullable_to_non_nullable
                  as bool?,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        rules: null == rules
            ? _self.rules
            : rules // ignore: cast_nullable_to_non_nullable
                  as List<AWSRekognitionRule>,
      ),
    );
  }
}
