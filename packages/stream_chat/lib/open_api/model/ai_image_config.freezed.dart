// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_image_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIImageConfig {
  bool? get async;
  bool get enabled;
  List<OCRRule> get ocrRules;
  List<AWSRekognitionRule> get rules;

  /// Create a copy of AIImageConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIImageConfigCopyWith<AIImageConfig> get copyWith =>
      _$AIImageConfigCopyWithImpl<AIImageConfig>(
        this as AIImageConfig,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIImageConfig &&
            (identical(other.async, async) || other.async == async) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality().equals(other.ocrRules, ocrRules) &&
            const DeepCollectionEquality().equals(other.rules, rules));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    async,
    enabled,
    const DeepCollectionEquality().hash(ocrRules),
    const DeepCollectionEquality().hash(rules),
  );

  @override
  String toString() {
    return 'AIImageConfig(async: $async, enabled: $enabled, ocrRules: $ocrRules, rules: $rules)';
  }
}

/// @nodoc
abstract mixin class $AIImageConfigCopyWith<$Res> {
  factory $AIImageConfigCopyWith(
    AIImageConfig value,
    $Res Function(AIImageConfig) _then,
  ) = _$AIImageConfigCopyWithImpl;
  @useResult
  $Res call({
    bool? async,
    bool enabled,
    List<OCRRule> ocrRules,
    List<AWSRekognitionRule> rules,
  });
}

/// @nodoc
class _$AIImageConfigCopyWithImpl<$Res>
    implements $AIImageConfigCopyWith<$Res> {
  _$AIImageConfigCopyWithImpl(this._self, this._then);

  final AIImageConfig _self;
  final $Res Function(AIImageConfig) _then;

  /// Create a copy of AIImageConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? async = freezed,
    Object? enabled = null,
    Object? ocrRules = null,
    Object? rules = null,
  }) {
    return _then(
      AIImageConfig(
        async: freezed == async
            ? _self.async
            : async // ignore: cast_nullable_to_non_nullable
                  as bool?,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        ocrRules: null == ocrRules
            ? _self.ocrRules
            : ocrRules // ignore: cast_nullable_to_non_nullable
                  as List<OCRRule>,
        rules: null == rules
            ? _self.rules
            : rules // ignore: cast_nullable_to_non_nullable
                  as List<AWSRekognitionRule>,
      ),
    );
  }
}
