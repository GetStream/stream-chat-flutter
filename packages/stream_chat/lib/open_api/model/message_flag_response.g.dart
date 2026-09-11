// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_flag_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageFlagResponse _$MessageFlagResponseFromJson(Map<String, dynamic> json) => MessageFlagResponse(
  approvedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['approved_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdByAutomod: json['created_by_automod'] as bool,
  custom: json['custom'] as Map<String, dynamic>?,
  details: json['details'] == null
      ? null
      : FlagDetailsResponse.fromJson(
          json['details'] as Map<String, dynamic>,
        ),
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  moderationFeedback: json['moderation_feedback'] == null
      ? null
      : FlagFeedbackResponse.fromJson(
          json['moderation_feedback'] as Map<String, dynamic>,
        ),
  moderationResult: json['moderation_result'] == null
      ? null
      : MessageModerationResult.fromJson(
          json['moderation_result'] as Map<String, dynamic>,
        ),
  reason: json['reason'] as String?,
  rejectedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['rejected_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reviewedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['reviewed_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reviewedBy: json['reviewed_by'] == null ? null : UserResponse.fromJson(json['reviewed_by'] as Map<String, dynamic>),
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: json['user'] == null ? null : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageFlagResponseToJson(
  MessageFlagResponse instance,
) => <String, dynamic>{
  'approved_at': _$JsonConverterToJson<Object, DateTime>(
    instance.approvedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by_automod': instance.createdByAutomod,
  'custom': instance.custom,
  'details': instance.details?.toJson(),
  'message': instance.message?.toJson(),
  'moderation_feedback': instance.moderationFeedback?.toJson(),
  'moderation_result': instance.moderationResult?.toJson(),
  'reason': instance.reason,
  'rejected_at': _$JsonConverterToJson<Object, DateTime>(
    instance.rejectedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'reviewed_at': _$JsonConverterToJson<Object, DateTime>(
    instance.reviewedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'reviewed_by': instance.reviewedBy?.toJson(),
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user?.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
