// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_queue_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewQueueItemResponse {
  List<ActionLogResponse> get actions;
  EnrichedActivity? get activity;
  String get aiTextSeverity;
  AppealItemResponse? get appeal;
  UserResponse? get assignedTo;
  List<BanInfoResponse> get bans;
  ModerationCallResponse? get call;
  DateTime? get completedAt;
  String? get configKey;
  DateTime get createdAt;
  EntityCreatorResponse? get entityCreator;
  String? get entityCreatorId;
  String get entityId;
  String get entityType;
  bool get escalated;
  DateTime? get escalatedAt;
  String? get escalatedBy;
  EscalationMetadata? get escalationMetadata;
  EnrichedActivity? get feedsV2Activity;
  Reaction? get feedsV2Reaction;
  FeedsV3ActivityResponse? get feedsV3Activity;
  FeedsV3CommentResponse? get feedsV3Comment;
  List<ModerationFlagResponse> get flags;
  int get flagsCount;
  String get id;
  List<String> get languages;
  String get latestModeratorAction;
  ChatMessageResponse? get message;
  ModerationPayloadResponse? get moderationPayload;
  Reaction? get reaction;
  String get recommendedAction;
  DateTime? get reviewedAt;
  String get reviewedBy;
  int get severity;
  String get status;
  List<String>? get teams;
  DateTime get updatedAt;

  /// Create a copy of ReviewQueueItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReviewQueueItemResponseCopyWith<ReviewQueueItemResponse> get copyWith =>
      _$ReviewQueueItemResponseCopyWithImpl<ReviewQueueItemResponse>(
        this as ReviewQueueItemResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReviewQueueItemResponse &&
            const DeepCollectionEquality().equals(other.actions, actions) &&
            (identical(other.activity, activity) ||
                other.activity == activity) &&
            (identical(other.aiTextSeverity, aiTextSeverity) ||
                other.aiTextSeverity == aiTextSeverity) &&
            (identical(other.appeal, appeal) || other.appeal == appeal) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            const DeepCollectionEquality().equals(other.bans, bans) &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.configKey, configKey) ||
                other.configKey == configKey) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.entityCreator, entityCreator) ||
                other.entityCreator == entityCreator) &&
            (identical(other.entityCreatorId, entityCreatorId) ||
                other.entityCreatorId == entityCreatorId) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.escalated, escalated) ||
                other.escalated == escalated) &&
            (identical(other.escalatedAt, escalatedAt) ||
                other.escalatedAt == escalatedAt) &&
            (identical(other.escalatedBy, escalatedBy) ||
                other.escalatedBy == escalatedBy) &&
            (identical(other.escalationMetadata, escalationMetadata) ||
                other.escalationMetadata == escalationMetadata) &&
            (identical(other.feedsV2Activity, feedsV2Activity) ||
                other.feedsV2Activity == feedsV2Activity) &&
            (identical(other.feedsV2Reaction, feedsV2Reaction) ||
                other.feedsV2Reaction == feedsV2Reaction) &&
            (identical(other.feedsV3Activity, feedsV3Activity) ||
                other.feedsV3Activity == feedsV3Activity) &&
            (identical(other.feedsV3Comment, feedsV3Comment) ||
                other.feedsV3Comment == feedsV3Comment) &&
            const DeepCollectionEquality().equals(other.flags, flags) &&
            (identical(other.flagsCount, flagsCount) ||
                other.flagsCount == flagsCount) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.languages, languages) &&
            (identical(other.latestModeratorAction, latestModeratorAction) ||
                other.latestModeratorAction == latestModeratorAction) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.moderationPayload, moderationPayload) ||
                other.moderationPayload == moderationPayload) &&
            (identical(other.reaction, reaction) ||
                other.reaction == reaction) &&
            (identical(other.recommendedAction, recommendedAction) ||
                other.recommendedAction == recommendedAction) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.teams, teams) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    const DeepCollectionEquality().hash(actions),
    activity,
    aiTextSeverity,
    appeal,
    assignedTo,
    const DeepCollectionEquality().hash(bans),
    call,
    completedAt,
    configKey,
    createdAt,
    entityCreator,
    entityCreatorId,
    entityId,
    entityType,
    escalated,
    escalatedAt,
    escalatedBy,
    escalationMetadata,
    feedsV2Activity,
    feedsV2Reaction,
    feedsV3Activity,
    feedsV3Comment,
    const DeepCollectionEquality().hash(flags),
    flagsCount,
    id,
    const DeepCollectionEquality().hash(languages),
    latestModeratorAction,
    message,
    moderationPayload,
    reaction,
    recommendedAction,
    reviewedAt,
    reviewedBy,
    severity,
    status,
    const DeepCollectionEquality().hash(teams),
    updatedAt,
  ]);

  @override
  String toString() {
    return 'ReviewQueueItemResponse(actions: $actions, activity: $activity, aiTextSeverity: $aiTextSeverity, appeal: $appeal, assignedTo: $assignedTo, bans: $bans, call: $call, completedAt: $completedAt, configKey: $configKey, createdAt: $createdAt, entityCreator: $entityCreator, entityCreatorId: $entityCreatorId, entityId: $entityId, entityType: $entityType, escalated: $escalated, escalatedAt: $escalatedAt, escalatedBy: $escalatedBy, escalationMetadata: $escalationMetadata, feedsV2Activity: $feedsV2Activity, feedsV2Reaction: $feedsV2Reaction, feedsV3Activity: $feedsV3Activity, feedsV3Comment: $feedsV3Comment, flags: $flags, flagsCount: $flagsCount, id: $id, languages: $languages, latestModeratorAction: $latestModeratorAction, message: $message, moderationPayload: $moderationPayload, reaction: $reaction, recommendedAction: $recommendedAction, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy, severity: $severity, status: $status, teams: $teams, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ReviewQueueItemResponseCopyWith<$Res> {
  factory $ReviewQueueItemResponseCopyWith(
    ReviewQueueItemResponse value,
    $Res Function(ReviewQueueItemResponse) _then,
  ) = _$ReviewQueueItemResponseCopyWithImpl;
  @useResult
  $Res call({
    List<ActionLogResponse> actions,
    EnrichedActivity? activity,
    String aiTextSeverity,
    AppealItemResponse? appeal,
    UserResponse? assignedTo,
    List<BanInfoResponse> bans,
    ModerationCallResponse? call,
    DateTime? completedAt,
    String? configKey,
    DateTime createdAt,
    EntityCreatorResponse? entityCreator,
    String? entityCreatorId,
    String entityId,
    String entityType,
    bool escalated,
    DateTime? escalatedAt,
    String? escalatedBy,
    EscalationMetadata? escalationMetadata,
    EnrichedActivity? feedsV2Activity,
    Reaction? feedsV2Reaction,
    FeedsV3ActivityResponse? feedsV3Activity,
    FeedsV3CommentResponse? feedsV3Comment,
    List<ModerationFlagResponse> flags,
    int flagsCount,
    String id,
    List<String> languages,
    String latestModeratorAction,
    ChatMessageResponse? message,
    ModerationPayloadResponse? moderationPayload,
    Reaction? reaction,
    String recommendedAction,
    DateTime? reviewedAt,
    String reviewedBy,
    int severity,
    String status,
    List<String>? teams,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ReviewQueueItemResponseCopyWithImpl<$Res>
    implements $ReviewQueueItemResponseCopyWith<$Res> {
  _$ReviewQueueItemResponseCopyWithImpl(this._self, this._then);

  final ReviewQueueItemResponse _self;
  final $Res Function(ReviewQueueItemResponse) _then;

  /// Create a copy of ReviewQueueItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actions = null,
    Object? activity = freezed,
    Object? aiTextSeverity = null,
    Object? appeal = freezed,
    Object? assignedTo = freezed,
    Object? bans = null,
    Object? call = freezed,
    Object? completedAt = freezed,
    Object? configKey = freezed,
    Object? createdAt = null,
    Object? entityCreator = freezed,
    Object? entityCreatorId = freezed,
    Object? entityId = null,
    Object? entityType = null,
    Object? escalated = null,
    Object? escalatedAt = freezed,
    Object? escalatedBy = freezed,
    Object? escalationMetadata = freezed,
    Object? feedsV2Activity = freezed,
    Object? feedsV2Reaction = freezed,
    Object? feedsV3Activity = freezed,
    Object? feedsV3Comment = freezed,
    Object? flags = null,
    Object? flagsCount = null,
    Object? id = null,
    Object? languages = null,
    Object? latestModeratorAction = null,
    Object? message = freezed,
    Object? moderationPayload = freezed,
    Object? reaction = freezed,
    Object? recommendedAction = null,
    Object? reviewedAt = freezed,
    Object? reviewedBy = null,
    Object? severity = null,
    Object? status = null,
    Object? teams = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      ReviewQueueItemResponse(
        actions: null == actions
            ? _self.actions
            : actions // ignore: cast_nullable_to_non_nullable
                  as List<ActionLogResponse>,
        activity: freezed == activity
            ? _self.activity
            : activity // ignore: cast_nullable_to_non_nullable
                  as EnrichedActivity?,
        aiTextSeverity: null == aiTextSeverity
            ? _self.aiTextSeverity
            : aiTextSeverity // ignore: cast_nullable_to_non_nullable
                  as String,
        appeal: freezed == appeal
            ? _self.appeal
            : appeal // ignore: cast_nullable_to_non_nullable
                  as AppealItemResponse?,
        assignedTo: freezed == assignedTo
            ? _self.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        bans: null == bans
            ? _self.bans
            : bans // ignore: cast_nullable_to_non_nullable
                  as List<BanInfoResponse>,
        call: freezed == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as ModerationCallResponse?,
        completedAt: freezed == completedAt
            ? _self.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        configKey: freezed == configKey
            ? _self.configKey
            : configKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        entityCreator: freezed == entityCreator
            ? _self.entityCreator
            : entityCreator // ignore: cast_nullable_to_non_nullable
                  as EntityCreatorResponse?,
        entityCreatorId: freezed == entityCreatorId
            ? _self.entityCreatorId
            : entityCreatorId // ignore: cast_nullable_to_non_nullable
                  as String?,
        entityId: null == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        escalated: null == escalated
            ? _self.escalated
            : escalated // ignore: cast_nullable_to_non_nullable
                  as bool,
        escalatedAt: freezed == escalatedAt
            ? _self.escalatedAt
            : escalatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        escalatedBy: freezed == escalatedBy
            ? _self.escalatedBy
            : escalatedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        escalationMetadata: freezed == escalationMetadata
            ? _self.escalationMetadata
            : escalationMetadata // ignore: cast_nullable_to_non_nullable
                  as EscalationMetadata?,
        feedsV2Activity: freezed == feedsV2Activity
            ? _self.feedsV2Activity
            : feedsV2Activity // ignore: cast_nullable_to_non_nullable
                  as EnrichedActivity?,
        feedsV2Reaction: freezed == feedsV2Reaction
            ? _self.feedsV2Reaction
            : feedsV2Reaction // ignore: cast_nullable_to_non_nullable
                  as Reaction?,
        feedsV3Activity: freezed == feedsV3Activity
            ? _self.feedsV3Activity
            : feedsV3Activity // ignore: cast_nullable_to_non_nullable
                  as FeedsV3ActivityResponse?,
        feedsV3Comment: freezed == feedsV3Comment
            ? _self.feedsV3Comment
            : feedsV3Comment // ignore: cast_nullable_to_non_nullable
                  as FeedsV3CommentResponse?,
        flags: null == flags
            ? _self.flags
            : flags // ignore: cast_nullable_to_non_nullable
                  as List<ModerationFlagResponse>,
        flagsCount: null == flagsCount
            ? _self.flagsCount
            : flagsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        languages: null == languages
            ? _self.languages
            : languages // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        latestModeratorAction: null == latestModeratorAction
            ? _self.latestModeratorAction
            : latestModeratorAction // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as ChatMessageResponse?,
        moderationPayload: freezed == moderationPayload
            ? _self.moderationPayload
            : moderationPayload // ignore: cast_nullable_to_non_nullable
                  as ModerationPayloadResponse?,
        reaction: freezed == reaction
            ? _self.reaction
            : reaction // ignore: cast_nullable_to_non_nullable
                  as Reaction?,
        recommendedAction: null == recommendedAction
            ? _self.recommendedAction
            : recommendedAction // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewedAt: freezed == reviewedAt
            ? _self.reviewedAt
            : reviewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewedBy: null == reviewedBy
            ? _self.reviewedBy
            : reviewedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: null == severity
            ? _self.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        teams: freezed == teams
            ? _self.teams
            : teams // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
