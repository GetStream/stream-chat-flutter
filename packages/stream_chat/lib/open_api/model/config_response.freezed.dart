// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConfigResponse {
  AIAudioConfigResponse? get aiAudioConfig;
  AIImageConfig? get aiImageConfig;
  List<AIImageLabelDefinition>? get aiImageLabelDefinitions;
  Map<String, List<String>>? get aiImageSubclassifications;
  AITextConfig? get aiTextConfig;
  AIVideoConfig? get aiVideoConfig;
  bool get async;
  AutomodPlatformCircumventionConfig? get automodPlatformCircumventionConfig;
  AutomodSemanticFiltersConfig? get automodSemanticFiltersConfig;
  AutomodToxicityConfig? get automodToxicityConfig;
  List<BodyguardProfileSummary>? get availableBodyguardProfiles;
  BlockListConfig? get blockListConfig;
  DateTime get createdAt;
  FloodConfig? get floodConfig;
  String get key;
  LLMConfig? get llmConfig;
  List<String> get supportedVideoCallHarmTypes;
  String get team;
  DateTime get updatedAt;
  VelocityFilterConfig? get velocityFilterConfig;
  VideoCallRuleConfig? get videoCallRuleConfig;

  /// Create a copy of ConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfigResponseCopyWith<ConfigResponse> get copyWith =>
      _$ConfigResponseCopyWithImpl<ConfigResponse>(
        this as ConfigResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConfigResponse &&
            (identical(other.aiAudioConfig, aiAudioConfig) ||
                other.aiAudioConfig == aiAudioConfig) &&
            (identical(other.aiImageConfig, aiImageConfig) ||
                other.aiImageConfig == aiImageConfig) &&
            const DeepCollectionEquality().equals(
              other.aiImageLabelDefinitions,
              aiImageLabelDefinitions,
            ) &&
            const DeepCollectionEquality().equals(
              other.aiImageSubclassifications,
              aiImageSubclassifications,
            ) &&
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
            const DeepCollectionEquality().equals(
              other.availableBodyguardProfiles,
              availableBodyguardProfiles,
            ) &&
            (identical(other.blockListConfig, blockListConfig) ||
                other.blockListConfig == blockListConfig) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.floodConfig, floodConfig) ||
                other.floodConfig == floodConfig) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.llmConfig, llmConfig) ||
                other.llmConfig == llmConfig) &&
            const DeepCollectionEquality().equals(
              other.supportedVideoCallHarmTypes,
              supportedVideoCallHarmTypes,
            ) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
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
    const DeepCollectionEquality().hash(aiImageLabelDefinitions),
    const DeepCollectionEquality().hash(aiImageSubclassifications),
    aiTextConfig,
    aiVideoConfig,
    async,
    automodPlatformCircumventionConfig,
    automodSemanticFiltersConfig,
    automodToxicityConfig,
    const DeepCollectionEquality().hash(availableBodyguardProfiles),
    blockListConfig,
    createdAt,
    floodConfig,
    key,
    llmConfig,
    const DeepCollectionEquality().hash(supportedVideoCallHarmTypes),
    team,
    updatedAt,
    velocityFilterConfig,
    videoCallRuleConfig,
  ]);

  @override
  String toString() {
    return 'ConfigResponse(aiAudioConfig: $aiAudioConfig, aiImageConfig: $aiImageConfig, aiImageLabelDefinitions: $aiImageLabelDefinitions, aiImageSubclassifications: $aiImageSubclassifications, aiTextConfig: $aiTextConfig, aiVideoConfig: $aiVideoConfig, async: $async, automodPlatformCircumventionConfig: $automodPlatformCircumventionConfig, automodSemanticFiltersConfig: $automodSemanticFiltersConfig, automodToxicityConfig: $automodToxicityConfig, availableBodyguardProfiles: $availableBodyguardProfiles, blockListConfig: $blockListConfig, createdAt: $createdAt, floodConfig: $floodConfig, key: $key, llmConfig: $llmConfig, supportedVideoCallHarmTypes: $supportedVideoCallHarmTypes, team: $team, updatedAt: $updatedAt, velocityFilterConfig: $velocityFilterConfig, videoCallRuleConfig: $videoCallRuleConfig)';
  }
}

/// @nodoc
abstract mixin class $ConfigResponseCopyWith<$Res> {
  factory $ConfigResponseCopyWith(
    ConfigResponse value,
    $Res Function(ConfigResponse) _then,
  ) = _$ConfigResponseCopyWithImpl;
  @useResult
  $Res call({
    AIAudioConfigResponse? aiAudioConfig,
    AIImageConfig? aiImageConfig,
    List<AIImageLabelDefinition>? aiImageLabelDefinitions,
    Map<String, List<String>>? aiImageSubclassifications,
    AITextConfig? aiTextConfig,
    AIVideoConfig? aiVideoConfig,
    bool async,
    AutomodPlatformCircumventionConfig? automodPlatformCircumventionConfig,
    AutomodSemanticFiltersConfig? automodSemanticFiltersConfig,
    AutomodToxicityConfig? automodToxicityConfig,
    List<BodyguardProfileSummary>? availableBodyguardProfiles,
    BlockListConfig? blockListConfig,
    DateTime createdAt,
    FloodConfig? floodConfig,
    String key,
    LLMConfig? llmConfig,
    List<String> supportedVideoCallHarmTypes,
    String team,
    DateTime updatedAt,
    VelocityFilterConfig? velocityFilterConfig,
    VideoCallRuleConfig? videoCallRuleConfig,
  });
}

/// @nodoc
class _$ConfigResponseCopyWithImpl<$Res>
    implements $ConfigResponseCopyWith<$Res> {
  _$ConfigResponseCopyWithImpl(this._self, this._then);

  final ConfigResponse _self;
  final $Res Function(ConfigResponse) _then;

  /// Create a copy of ConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiAudioConfig = freezed,
    Object? aiImageConfig = freezed,
    Object? aiImageLabelDefinitions = freezed,
    Object? aiImageSubclassifications = freezed,
    Object? aiTextConfig = freezed,
    Object? aiVideoConfig = freezed,
    Object? async = null,
    Object? automodPlatformCircumventionConfig = freezed,
    Object? automodSemanticFiltersConfig = freezed,
    Object? automodToxicityConfig = freezed,
    Object? availableBodyguardProfiles = freezed,
    Object? blockListConfig = freezed,
    Object? createdAt = null,
    Object? floodConfig = freezed,
    Object? key = null,
    Object? llmConfig = freezed,
    Object? supportedVideoCallHarmTypes = null,
    Object? team = null,
    Object? updatedAt = null,
    Object? velocityFilterConfig = freezed,
    Object? videoCallRuleConfig = freezed,
  }) {
    return _then(
      ConfigResponse(
        aiAudioConfig: freezed == aiAudioConfig
            ? _self.aiAudioConfig
            : aiAudioConfig // ignore: cast_nullable_to_non_nullable
                  as AIAudioConfigResponse?,
        aiImageConfig: freezed == aiImageConfig
            ? _self.aiImageConfig
            : aiImageConfig // ignore: cast_nullable_to_non_nullable
                  as AIImageConfig?,
        aiImageLabelDefinitions: freezed == aiImageLabelDefinitions
            ? _self.aiImageLabelDefinitions
            : aiImageLabelDefinitions // ignore: cast_nullable_to_non_nullable
                  as List<AIImageLabelDefinition>?,
        aiImageSubclassifications: freezed == aiImageSubclassifications
            ? _self.aiImageSubclassifications
            : aiImageSubclassifications // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>?,
        aiTextConfig: freezed == aiTextConfig
            ? _self.aiTextConfig
            : aiTextConfig // ignore: cast_nullable_to_non_nullable
                  as AITextConfig?,
        aiVideoConfig: freezed == aiVideoConfig
            ? _self.aiVideoConfig
            : aiVideoConfig // ignore: cast_nullable_to_non_nullable
                  as AIVideoConfig?,
        async: null == async
            ? _self.async
            : async // ignore: cast_nullable_to_non_nullable
                  as bool,
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
        availableBodyguardProfiles: freezed == availableBodyguardProfiles
            ? _self.availableBodyguardProfiles
            : availableBodyguardProfiles // ignore: cast_nullable_to_non_nullable
                  as List<BodyguardProfileSummary>?,
        blockListConfig: freezed == blockListConfig
            ? _self.blockListConfig
            : blockListConfig // ignore: cast_nullable_to_non_nullable
                  as BlockListConfig?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        floodConfig: freezed == floodConfig
            ? _self.floodConfig
            : floodConfig // ignore: cast_nullable_to_non_nullable
                  as FloodConfig?,
        key: null == key
            ? _self.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        llmConfig: freezed == llmConfig
            ? _self.llmConfig
            : llmConfig // ignore: cast_nullable_to_non_nullable
                  as LLMConfig?,
        supportedVideoCallHarmTypes: null == supportedVideoCallHarmTypes
            ? _self.supportedVideoCallHarmTypes
            : supportedVideoCallHarmTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        team: null == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
