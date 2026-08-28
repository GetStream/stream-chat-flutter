// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_queue_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewQueueItemResponse _$ReviewQueueItemResponseFromJson(
  Map<String, dynamic> json,
) => ReviewQueueItemResponse(
  actions: (json['actions'] as List<dynamic>)
      .map((e) => ActionLogResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  activity: json['activity'] == null
      ? null
      : EnrichedActivity.fromJson(json['activity'] as Map<String, dynamic>),
  aiTextSeverity: json['ai_text_severity'] as String,
  appeal: json['appeal'] == null
      ? null
      : AppealItemResponse.fromJson(json['appeal'] as Map<String, dynamic>),
  assignedTo: json['assigned_to'] == null
      ? null
      : UserResponse.fromJson(json['assigned_to'] as Map<String, dynamic>),
  bans: (json['bans'] as List<dynamic>)
      .map((e) => BanInfoResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  call: json['call'] == null
      ? null
      : ModerationCallResponse.fromJson(json['call'] as Map<String, dynamic>),
  completedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['completed_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  configKey: json['config_key'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  entityCreator: json['entity_creator'] == null
      ? null
      : EntityCreatorResponse.fromJson(
          json['entity_creator'] as Map<String, dynamic>,
        ),
  entityCreatorId: json['entity_creator_id'] as String?,
  entityId: json['entity_id'] as String,
  entityType: json['entity_type'] as String,
  escalated: json['escalated'] as bool,
  escalatedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['escalated_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  escalatedBy: json['escalated_by'] as String?,
  escalationMetadata: json['escalation_metadata'] == null
      ? null
      : EscalationMetadata.fromJson(
          json['escalation_metadata'] as Map<String, dynamic>,
        ),
  feedsV2Activity: json['feeds_v2_activity'] == null
      ? null
      : EnrichedActivity.fromJson(
          json['feeds_v2_activity'] as Map<String, dynamic>,
        ),
  feedsV2Reaction: json['feeds_v2_reaction'] == null
      ? null
      : Reaction.fromJson(json['feeds_v2_reaction'] as Map<String, dynamic>),
  feedsV3Activity: json['feeds_v3_activity'] == null
      ? null
      : FeedsV3ActivityResponse.fromJson(
          json['feeds_v3_activity'] as Map<String, dynamic>,
        ),
  feedsV3Comment: json['feeds_v3_comment'] == null
      ? null
      : FeedsV3CommentResponse.fromJson(
          json['feeds_v3_comment'] as Map<String, dynamic>,
        ),
  flags: (json['flags'] as List<dynamic>)
      .map((e) => ModerationFlagResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  flagsCount: (json['flags_count'] as num).toInt(),
  id: json['id'] as String,
  languages: (json['languages'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  latestModeratorAction: json['latest_moderator_action'] as String,
  message: json['message'] == null
      ? null
      : ChatMessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  moderationPayload: json['moderation_payload'] == null
      ? null
      : ModerationPayloadResponse.fromJson(
          json['moderation_payload'] as Map<String, dynamic>,
        ),
  reaction: json['reaction'] == null
      ? null
      : Reaction.fromJson(json['reaction'] as Map<String, dynamic>),
  recommendedAction: json['recommended_action'] as String,
  reviewedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['reviewed_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reviewedBy: json['reviewed_by'] as String,
  severity: (json['severity'] as num).toInt(),
  status: json['status'] as String,
  teams: (json['teams'] as List<dynamic>?)?.map((e) => e as String).toList(),
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$ReviewQueueItemResponseToJson(
  ReviewQueueItemResponse instance,
) => <String, dynamic>{
  'actions': instance.actions.map((e) => e.toJson()).toList(),
  'activity': instance.activity?.toJson(),
  'ai_text_severity': instance.aiTextSeverity,
  'appeal': instance.appeal?.toJson(),
  'assigned_to': instance.assignedTo?.toJson(),
  'bans': instance.bans.map((e) => e.toJson()).toList(),
  'call': instance.call?.toJson(),
  'completed_at': _$JsonConverterToJson<Object, DateTime>(
    instance.completedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'config_key': instance.configKey,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'entity_creator': instance.entityCreator?.toJson(),
  'entity_creator_id': instance.entityCreatorId,
  'entity_id': instance.entityId,
  'entity_type': instance.entityType,
  'escalated': instance.escalated,
  'escalated_at': _$JsonConverterToJson<Object, DateTime>(
    instance.escalatedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'escalated_by': instance.escalatedBy,
  'escalation_metadata': instance.escalationMetadata?.toJson(),
  'feeds_v2_activity': instance.feedsV2Activity?.toJson(),
  'feeds_v2_reaction': instance.feedsV2Reaction?.toJson(),
  'feeds_v3_activity': instance.feedsV3Activity?.toJson(),
  'feeds_v3_comment': instance.feedsV3Comment?.toJson(),
  'flags': instance.flags.map((e) => e.toJson()).toList(),
  'flags_count': instance.flagsCount,
  'id': instance.id,
  'languages': instance.languages,
  'latest_moderator_action': instance.latestModeratorAction,
  'message': instance.message?.toJson(),
  'moderation_payload': instance.moderationPayload?.toJson(),
  'reaction': instance.reaction?.toJson(),
  'recommended_action': instance.recommendedAction,
  'reviewed_at': _$JsonConverterToJson<Object, DateTime>(
    instance.reviewedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'reviewed_by': instance.reviewedBy,
  'severity': instance.severity,
  'status': instance.status,
  'teams': instance.teams,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
