// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_audio_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIAudioConfigResponse {
  AITextConfig? get aiTextConfig;
  bool get enabled;
  LLMConfig? get llmConfig;
  String get profile;
  List<BodyguardRule> get rules;

  /// Create a copy of AIAudioConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIAudioConfigResponseCopyWith<AIAudioConfigResponse> get copyWith =>
      _$AIAudioConfigResponseCopyWithImpl<AIAudioConfigResponse>(
        this as AIAudioConfigResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIAudioConfigResponse &&
            (identical(other.aiTextConfig, aiTextConfig) || other.aiTextConfig == aiTextConfig) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.llmConfig, llmConfig) || other.llmConfig == llmConfig) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality().equals(other.rules, rules));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    aiTextConfig,
    enabled,
    llmConfig,
    profile,
    const DeepCollectionEquality().hash(rules),
  );

  @override
  String toString() {
    return 'AIAudioConfigResponse(aiTextConfig: $aiTextConfig, enabled: $enabled, llmConfig: $llmConfig, profile: $profile, rules: $rules)';
  }
}

/// @nodoc
abstract mixin class $AIAudioConfigResponseCopyWith<$Res> {
  factory $AIAudioConfigResponseCopyWith(
    AIAudioConfigResponse value,
    $Res Function(AIAudioConfigResponse) _then,
  ) = _$AIAudioConfigResponseCopyWithImpl;
  @useResult
  $Res call({
    AITextConfig? aiTextConfig,
    bool enabled,
    LLMConfig? llmConfig,
    String profile,
    List<BodyguardRule> rules,
  });
}

/// @nodoc
class _$AIAudioConfigResponseCopyWithImpl<$Res> implements $AIAudioConfigResponseCopyWith<$Res> {
  _$AIAudioConfigResponseCopyWithImpl(this._self, this._then);

  final AIAudioConfigResponse _self;
  final $Res Function(AIAudioConfigResponse) _then;

  /// Create a copy of AIAudioConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiTextConfig = freezed,
    Object? enabled = null,
    Object? llmConfig = freezed,
    Object? profile = null,
    Object? rules = null,
  }) {
    return _then(
      AIAudioConfigResponse(
        aiTextConfig: freezed == aiTextConfig
            ? _self.aiTextConfig
            : aiTextConfig // ignore: cast_nullable_to_non_nullable
                  as AITextConfig?,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        llmConfig: freezed == llmConfig
            ? _self.llmConfig
            : llmConfig // ignore: cast_nullable_to_non_nullable
                  as LLMConfig?,
        profile: null == profile
            ? _self.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as String,
        rules: null == rules
            ? _self.rules
            : rules // ignore: cast_nullable_to_non_nullable
                  as List<BodyguardRule>,
      ),
    );
  }
}
