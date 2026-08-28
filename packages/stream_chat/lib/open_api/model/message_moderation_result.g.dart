// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_moderation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModerationResult _$MessageModerationResultFromJson(
  Map<String, dynamic> json,
) => MessageModerationResult(
  action: json['action'] as String,
  aiModerationResponse: json['ai_moderation_response'] == null
      ? null
      : ModerationResponse.fromJson(
          json['ai_moderation_response'] as Map<String, dynamic>,
        ),
  blockedWord: json['blocked_word'] as String?,
  blocklistName: json['blocklist_name'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  messageId: json['message_id'] as String,
  moderatedBy: json['moderated_by'] as String?,
  moderationThresholds: json['moderation_thresholds'] == null
      ? null
      : Thresholds.fromJson(
          json['moderation_thresholds'] as Map<String, dynamic>,
        ),
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  userBadKarma: json['user_bad_karma'] as bool,
  userKarma: (json['user_karma'] as num).toDouble(),
);

Map<String, dynamic> _$MessageModerationResultToJson(
  MessageModerationResult instance,
) => <String, dynamic>{
  'action': instance.action,
  'ai_moderation_response': instance.aiModerationResponse?.toJson(),
  'blocked_word': instance.blockedWord,
  'blocklist_name': instance.blocklistName,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'message_id': instance.messageId,
  'moderated_by': instance.moderatedBy,
  'moderation_thresholds': instance.moderationThresholds?.toJson(),
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user_bad_karma': instance.userBadKarma,
  'user_karma': instance.userKarma,
};
