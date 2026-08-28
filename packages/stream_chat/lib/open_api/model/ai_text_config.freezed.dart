// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_text_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AITextConfig {
  bool? get async;
  bool get enabled;
  String get profile;
  List<BodyguardRule> get rules;
  List<BodyguardSeverityRule> get severityRules;

  /// Create a copy of AITextConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AITextConfigCopyWith<AITextConfig> get copyWith =>
      _$AITextConfigCopyWithImpl<AITextConfig>(
        this as AITextConfig,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AITextConfig &&
            (identical(other.async, async) || other.async == async) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality().equals(other.rules, rules) &&
            const DeepCollectionEquality().equals(
              other.severityRules,
              severityRules,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    async,
    enabled,
    profile,
    const DeepCollectionEquality().hash(rules),
    const DeepCollectionEquality().hash(severityRules),
  );

  @override
  String toString() {
    return 'AITextConfig(async: $async, enabled: $enabled, profile: $profile, rules: $rules, severityRules: $severityRules)';
  }
}

/// @nodoc
abstract mixin class $AITextConfigCopyWith<$Res> {
  factory $AITextConfigCopyWith(
    AITextConfig value,
    $Res Function(AITextConfig) _then,
  ) = _$AITextConfigCopyWithImpl;
  @useResult
  $Res call({
    bool? async,
    bool enabled,
    String profile,
    List<BodyguardRule> rules,
    List<BodyguardSeverityRule> severityRules,
  });
}

/// @nodoc
class _$AITextConfigCopyWithImpl<$Res> implements $AITextConfigCopyWith<$Res> {
  _$AITextConfigCopyWithImpl(this._self, this._then);

  final AITextConfig _self;
  final $Res Function(AITextConfig) _then;

  /// Create a copy of AITextConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? async = freezed,
    Object? enabled = null,
    Object? profile = null,
    Object? rules = null,
    Object? severityRules = null,
  }) {
    return _then(
      AITextConfig(
        async: freezed == async
            ? _self.async
            : async // ignore: cast_nullable_to_non_nullable
                  as bool?,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        profile: null == profile
            ? _self.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as String,
        rules: null == rules
            ? _self.rules
            : rules // ignore: cast_nullable_to_non_nullable
                  as List<BodyguardRule>,
        severityRules: null == severityRules
            ? _self.severityRules
            : severityRules // ignore: cast_nullable_to_non_nullable
                  as List<BodyguardSeverityRule>,
      ),
    );
  }
}
