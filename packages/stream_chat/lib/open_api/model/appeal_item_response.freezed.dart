// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appeal_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppealItemResponse {
  List<ActionLogResponse>? get actions;
  String? get aiTextSeverity;
  String get appealReason;
  List<String>? get attachments;
  String? get channelCid;
  String? get configKey;
  DateTime get createdAt;
  String? get decisionReason;
  ModerationPayload? get entityContent;
  String get entityId;
  String get entityType;
  List<String>? get flagLabels;
  List<String>? get flagTypes;
  List<ModerationFlagResponse>? get flags;
  String get id;
  ActionLogResponse? get moderationAction;
  ActionLogResponse? get originalModerationAction;
  String? get recommendedAction;
  String? get reviewQueueItemId;
  int? get severity;
  String get status;
  DateTime get updatedAt;
  UserResponse? get user;

  /// Create a copy of AppealItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppealItemResponseCopyWith<AppealItemResponse> get copyWith =>
      _$AppealItemResponseCopyWithImpl<AppealItemResponse>(
        this as AppealItemResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppealItemResponse &&
            const DeepCollectionEquality().equals(other.actions, actions) &&
            (identical(other.aiTextSeverity, aiTextSeverity) ||
                other.aiTextSeverity == aiTextSeverity) &&
            (identical(other.appealReason, appealReason) ||
                other.appealReason == appealReason) &&
            const DeepCollectionEquality().equals(
              other.attachments,
              attachments,
            ) &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.configKey, configKey) ||
                other.configKey == configKey) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.decisionReason, decisionReason) ||
                other.decisionReason == decisionReason) &&
            (identical(other.entityContent, entityContent) ||
                other.entityContent == entityContent) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            const DeepCollectionEquality().equals(
              other.flagLabels,
              flagLabels,
            ) &&
            const DeepCollectionEquality().equals(other.flagTypes, flagTypes) &&
            const DeepCollectionEquality().equals(other.flags, flags) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.moderationAction, moderationAction) ||
                other.moderationAction == moderationAction) &&
            (identical(
                  other.originalModerationAction,
                  originalModerationAction,
                ) ||
                other.originalModerationAction == originalModerationAction) &&
            (identical(other.recommendedAction, recommendedAction) ||
                other.recommendedAction == recommendedAction) &&
            (identical(other.reviewQueueItemId, reviewQueueItemId) ||
                other.reviewQueueItemId == reviewQueueItemId) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    const DeepCollectionEquality().hash(actions),
    aiTextSeverity,
    appealReason,
    const DeepCollectionEquality().hash(attachments),
    channelCid,
    configKey,
    createdAt,
    decisionReason,
    entityContent,
    entityId,
    entityType,
    const DeepCollectionEquality().hash(flagLabels),
    const DeepCollectionEquality().hash(flagTypes),
    const DeepCollectionEquality().hash(flags),
    id,
    moderationAction,
    originalModerationAction,
    recommendedAction,
    reviewQueueItemId,
    severity,
    status,
    updatedAt,
    user,
  ]);

  @override
  String toString() {
    return 'AppealItemResponse(actions: $actions, aiTextSeverity: $aiTextSeverity, appealReason: $appealReason, attachments: $attachments, channelCid: $channelCid, configKey: $configKey, createdAt: $createdAt, decisionReason: $decisionReason, entityContent: $entityContent, entityId: $entityId, entityType: $entityType, flagLabels: $flagLabels, flagTypes: $flagTypes, flags: $flags, id: $id, moderationAction: $moderationAction, originalModerationAction: $originalModerationAction, recommendedAction: $recommendedAction, reviewQueueItemId: $reviewQueueItemId, severity: $severity, status: $status, updatedAt: $updatedAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class $AppealItemResponseCopyWith<$Res> {
  factory $AppealItemResponseCopyWith(
    AppealItemResponse value,
    $Res Function(AppealItemResponse) _then,
  ) = _$AppealItemResponseCopyWithImpl;
  @useResult
  $Res call({
    List<ActionLogResponse>? actions,
    String? aiTextSeverity,
    String appealReason,
    List<String>? attachments,
    String? channelCid,
    String? configKey,
    DateTime createdAt,
    String? decisionReason,
    ModerationPayload? entityContent,
    String entityId,
    String entityType,
    List<String>? flagLabels,
    List<String>? flagTypes,
    List<ModerationFlagResponse>? flags,
    String id,
    ActionLogResponse? moderationAction,
    ActionLogResponse? originalModerationAction,
    String? recommendedAction,
    String? reviewQueueItemId,
    int? severity,
    String status,
    DateTime updatedAt,
    UserResponse? user,
  });
}

/// @nodoc
class _$AppealItemResponseCopyWithImpl<$Res>
    implements $AppealItemResponseCopyWith<$Res> {
  _$AppealItemResponseCopyWithImpl(this._self, this._then);

  final AppealItemResponse _self;
  final $Res Function(AppealItemResponse) _then;

  /// Create a copy of AppealItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actions = freezed,
    Object? aiTextSeverity = freezed,
    Object? appealReason = null,
    Object? attachments = freezed,
    Object? channelCid = freezed,
    Object? configKey = freezed,
    Object? createdAt = null,
    Object? decisionReason = freezed,
    Object? entityContent = freezed,
    Object? entityId = null,
    Object? entityType = null,
    Object? flagLabels = freezed,
    Object? flagTypes = freezed,
    Object? flags = freezed,
    Object? id = null,
    Object? moderationAction = freezed,
    Object? originalModerationAction = freezed,
    Object? recommendedAction = freezed,
    Object? reviewQueueItemId = freezed,
    Object? severity = freezed,
    Object? status = null,
    Object? updatedAt = null,
    Object? user = freezed,
  }) {
    return _then(
      AppealItemResponse(
        actions: freezed == actions
            ? _self.actions
            : actions // ignore: cast_nullable_to_non_nullable
                  as List<ActionLogResponse>?,
        aiTextSeverity: freezed == aiTextSeverity
            ? _self.aiTextSeverity
            : aiTextSeverity // ignore: cast_nullable_to_non_nullable
                  as String?,
        appealReason: null == appealReason
            ? _self.appealReason
            : appealReason // ignore: cast_nullable_to_non_nullable
                  as String,
        attachments: freezed == attachments
            ? _self.attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        channelCid: freezed == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String?,
        configKey: freezed == configKey
            ? _self.configKey
            : configKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        decisionReason: freezed == decisionReason
            ? _self.decisionReason
            : decisionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        entityContent: freezed == entityContent
            ? _self.entityContent
            : entityContent // ignore: cast_nullable_to_non_nullable
                  as ModerationPayload?,
        entityId: null == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        flagLabels: freezed == flagLabels
            ? _self.flagLabels
            : flagLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        flagTypes: freezed == flagTypes
            ? _self.flagTypes
            : flagTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        flags: freezed == flags
            ? _self.flags
            : flags // ignore: cast_nullable_to_non_nullable
                  as List<ModerationFlagResponse>?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        moderationAction: freezed == moderationAction
            ? _self.moderationAction
            : moderationAction // ignore: cast_nullable_to_non_nullable
                  as ActionLogResponse?,
        originalModerationAction: freezed == originalModerationAction
            ? _self.originalModerationAction
            : originalModerationAction // ignore: cast_nullable_to_non_nullable
                  as ActionLogResponse?,
        recommendedAction: freezed == recommendedAction
            ? _self.recommendedAction
            : recommendedAction // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewQueueItemId: freezed == reviewQueueItemId
            ? _self.reviewQueueItemId
            : reviewQueueItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        severity: freezed == severity
            ? _self.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
      ),
    );
  }
}
