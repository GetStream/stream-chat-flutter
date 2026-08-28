// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upsert_config_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpsertConfigRequest {
  AIAudioConfigRequest? get aiAudioConfig;
  AIImageConfig? get aiImageConfig;
  AITextConfig? get aiTextConfig;
  AIVideoConfig? get aiVideoConfig;
  bool? get async;
  AutomodPlatformCircumventionConfig? get automodPlatformCircumventionConfig;
  AutomodSemanticFiltersConfig? get automodSemanticFiltersConfig;
  AutomodToxicityConfig? get automodToxicityConfig;
  AIImageConfig? get awsRekognitionConfig;
  BlockListConfig? get blockListConfig;
  AITextConfig? get bodyguardConfig;
  FloodConfig? get floodConfig;
  GoogleVisionConfig? get googleVisionConfig;
  String get key;
  LLMConfig? get llmConfig;
  RuleBuilderConfig? get ruleBuilderConfig;
  String? get team;
  VelocityFilterConfig? get velocityFilterConfig;
  VideoCallRuleConfig? get videoCallRuleConfig;

  /// Create a copy of UpsertConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpsertConfigRequestCopyWith<UpsertConfigRequest> get copyWith =>
      _$UpsertConfigRequestCopyWithImpl<UpsertConfigRequest>(
        this as UpsertConfigRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpsertConfigRequest &&
            (identical(other.aiAudioConfig, aiAudioConfig) ||
                other.aiAudioConfig == aiAudioConfig) &&
            (identical(other.aiImageConfig, aiImageConfig) ||
                other.aiImageConfig == aiImageConfig) &&
            (identical(other.aiTextConfig, aiTextConfig) ||
                other.aiTextConfig == aiTextConfig) &&
            (identical(other.aiVideoConfig, aiVideoConfig) ||
                other.aiVideoConfig == aiVideoConfig) &&
            (identical(other.async, async) || other.async == async) &&
            (identical(
                  other.automodPlatformCircumventionConfig,
                  automodPlatformCircumventionConfig,
                ) ||
                other.automodPlatformCircumventionConfig ==
                    automodPlatformCircumventionConfig) &&
            (identical(
                  other.automodSemanticFiltersConfig,
                  automodSemanticFiltersConfig,
                ) ||
                other.automodSemanticFiltersConfig ==
                    automodSemanticFiltersConfig) &&
            (identical(other.automodToxicityConfig, automodToxicityConfig) ||
                other.automodToxicityConfig == automodToxicityConfig) &&
            (identical(other.awsRekognitionConfig, awsRekognitionConfig) ||
                other.awsRekognitionConfig == awsRekognitionConfig) &&
            (identical(other.blockListConfig, blockListConfig) ||
                other.blockListConfig == blockListConfig) &&
            (identical(other.bodyguardConfig, bodyguardConfig) ||
                other.bodyguardConfig == bodyguardConfig) &&
            (identical(other.floodConfig, floodConfig) ||
                other.floodConfig == floodConfig) &&
            (identical(other.googleVisionConfig, googleVisionConfig) ||
                other.googleVisionConfig == googleVisionConfig) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.llmConfig, llmConfig) ||
                other.llmConfig == llmConfig) &&
            (identical(other.ruleBuilderConfig, ruleBuilderConfig) ||
                other.ruleBuilderConfig == ruleBuilderConfig) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.velocityFilterConfig, velocityFilterConfig) ||
                other.velocityFilterConfig == velocityFilterConfig) &&
            (identical(other.videoCallRuleConfig, videoCallRuleConfig) ||
                other.videoCallRuleConfig == videoCallRuleConfig));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    aiAudioConfig,
    aiImageConfig,
    aiTextConfig,
    aiVideoConfig,
    async,
    automodPlatformCircumventionConfig,
    automodSemanticFiltersConfig,
    automodToxicityConfig,
    awsRekognitionConfig,
    blockListConfig,
    bodyguardConfig,
    floodConfig,
    googleVisionConfig,
    key,
    llmConfig,
    ruleBuilderConfig,
    team,
    velocityFilterConfig,
    videoCallRuleConfig,
  ]);

  @override
  String toString() {
    return 'UpsertConfigRequest(aiAudioConfig: $aiAudioConfig, aiImageConfig: $aiImageConfig, aiTextConfig: $aiTextConfig, aiVideoConfig: $aiVideoConfig, async: $async, automodPlatformCircumventionConfig: $automodPlatformCircumventionConfig, automodSemanticFiltersConfig: $automodSemanticFiltersConfig, automodToxicityConfig: $automodToxicityConfig, awsRekognitionConfig: $awsRekognitionConfig, blockListConfig: $blockListConfig, bodyguardConfig: $bodyguardConfig, floodConfig: $floodConfig, googleVisionConfig: $googleVisionConfig, key: $key, llmConfig: $llmConfig, ruleBuilderConfig: $ruleBuilderConfig, team: $team, velocityFilterConfig: $velocityFilterConfig, videoCallRuleConfig: $videoCallRuleConfig)';
  }
}

/// @nodoc
abstract mixin class $UpsertConfigRequestCopyWith<$Res> {
  factory $UpsertConfigRequestCopyWith(
    UpsertConfigRequest value,
    $Res Function(UpsertConfigRequest) _then,
  ) = _$UpsertConfigRequestCopyWithImpl;
  @useResult
  $Res call({
    AIAudioConfigRequest? aiAudioConfig,
    AIImageConfig? aiImageConfig,
    AITextConfig? aiTextConfig,
    AIVideoConfig? aiVideoConfig,
    bool? async,
    AutomodPlatformCircumventionConfig? automodPlatformCircumventionConfig,
    AutomodSemanticFiltersConfig? automodSemanticFiltersConfig,
    AutomodToxicityConfig? automodToxicityConfig,
    AIImageConfig? awsRekognitionConfig,
    BlockListConfig? blockListConfig,
    AITextConfig? bodyguardConfig,
    FloodConfig? floodConfig,
    GoogleVisionConfig? googleVisionConfig,
    String key,
    LLMConfig? llmConfig,
    RuleBuilderConfig? ruleBuilderConfig,
    String? team,
    VelocityFilterConfig? velocityFilterConfig,
    VideoCallRuleConfig? videoCallRuleConfig,
  });
}

/// @nodoc
class _$UpsertConfigRequestCopyWithImpl<$Res>
    implements $UpsertConfigRequestCopyWith<$Res> {
  _$UpsertConfigRequestCopyWithImpl(this._self, this._then);

  final UpsertConfigRequest _self;
  final $Res Function(UpsertConfigRequest) _then;

  /// Create a copy of UpsertConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiAudioConfig = freezed,
    Object? aiImageConfig = freezed,
    Object? aiTextConfig = freezed,
    Object? aiVideoConfig = freezed,
    Object? async = freezed,
    Object? automodPlatformCircumventionConfig = freezed,
    Object? automodSemanticFiltersConfig = freezed,
    Object? automodToxicityConfig = freezed,
    Object? awsRekognitionConfig = freezed,
    Object? blockListConfig = freezed,
    Object? bodyguardConfig = freezed,
    Object? floodConfig = freezed,
    Object? googleVisionConfig = freezed,
    Object? key = null,
    Object? llmConfig = freezed,
    Object? ruleBuilderConfig = freezed,
    Object? team = freezed,
    Object? velocityFilterConfig = freezed,
    Object? videoCallRuleConfig = freezed,
  }) {
    return _then(
      UpsertConfigRequest(
        aiAudioConfig: freezed == aiAudioConfig
            ? _self.aiAudioConfig
            : aiAudioConfig // ignore: cast_nullable_to_non_nullable
                  as AIAudioConfigRequest?,
        aiImageConfig: freezed == aiImageConfig
            ? _self.aiImageConfig
            : aiImageConfig // ignore: cast_nullable_to_non_nullable
                  as AIImageConfig?,
        aiTextConfig: freezed == aiTextConfig
            ? _self.aiTextConfig
            : aiTextConfig // ignore: cast_nullable_to_non_nullable
                  as AITextConfig?,
        aiVideoConfig: freezed == aiVideoConfig
            ? _self.aiVideoConfig
            : aiVideoConfig // ignore: cast_nullable_to_non_nullable
                  as AIVideoConfig?,
        async: freezed == async
            ? _self.async
            : async // ignore: cast_nullable_to_non_nullable
                  as bool?,
        automodPlatformCircumventionConfig:
            freezed == automodPlatformCircumventionConfig
            ? _self.automodPlatformCircumventionConfig
            : automodPlatformCircumventionConfig // ignore: cast_nullable_to_non_nullable
                  as AutomodPlatformCircumventionConfig?,
        automodSemanticFiltersConfig: freezed == automodSemanticFiltersConfig
            ? _self.automodSemanticFiltersConfig
            : automodSemanticFiltersConfig // ignore: cast_nullable_to_non_nullable
                  as AutomodSemanticFiltersConfig?,
        automodToxicityConfig: freezed == automodToxicityConfig
            ? _self.automodToxicityConfig
            : automodToxicityConfig // ignore: cast_nullable_to_non_nullable
                  as AutomodToxicityConfig?,
        awsRekognitionConfig: freezed == awsRekognitionConfig
            ? _self.awsRekognitionConfig
            : awsRekognitionConfig // ignore: cast_nullable_to_non_nullable
                  as AIImageConfig?,
        blockListConfig: freezed == blockListConfig
            ? _self.blockListConfig
            : blockListConfig // ignore: cast_nullable_to_non_nullable
                  as BlockListConfig?,
        bodyguardConfig: freezed == bodyguardConfig
            ? _self.bodyguardConfig
            : bodyguardConfig // ignore: cast_nullable_to_non_nullable
                  as AITextConfig?,
        floodConfig: freezed == floodConfig
            ? _self.floodConfig
            : floodConfig // ignore: cast_nullable_to_non_nullable
                  as FloodConfig?,
        googleVisionConfig: freezed == googleVisionConfig
            ? _self.googleVisionConfig
            : googleVisionConfig // ignore: cast_nullable_to_non_nullable
                  as GoogleVisionConfig?,
        key: null == key
            ? _self.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        llmConfig: freezed == llmConfig
            ? _self.llmConfig
            : llmConfig // ignore: cast_nullable_to_non_nullable
                  as LLMConfig?,
        ruleBuilderConfig: freezed == ruleBuilderConfig
            ? _self.ruleBuilderConfig
            : ruleBuilderConfig // ignore: cast_nullable_to_non_nullable
                  as RuleBuilderConfig?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        velocityFilterConfig: freezed == velocityFilterConfig
            ? _self.velocityFilterConfig
            : velocityFilterConfig // ignore: cast_nullable_to_non_nullable
                  as VelocityFilterConfig?,
        videoCallRuleConfig: freezed == videoCallRuleConfig
            ? _self.videoCallRuleConfig
            : videoCallRuleConfig // ignore: cast_nullable_to_non_nullable
                  as VideoCallRuleConfig?,
      ),
    );
  }
}
