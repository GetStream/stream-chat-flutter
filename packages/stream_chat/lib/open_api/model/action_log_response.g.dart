// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_log_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionLogResponse _$ActionLogResponseFromJson(Map<String, dynamic> json) =>
    ActionLogResponse(
      aiProviders: (json['ai_providers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      id: json['id'] as String,
      reason: json['reason'] as String,
      reporterType: json['reporter_type'] as String,
      reviewQueueItem: json['review_queue_item'] == null
          ? null
          : ReviewQueueItemResponse.fromJson(
              json['review_queue_item'] as Map<String, dynamic>,
            ),
      targetUser: json['target_user'] == null
          ? null
          : UserResponse.fromJson(json['target_user'] as Map<String, dynamic>),
      targetUserId: json['target_user_id'] as String,
      type: json['type'] as String,
      user: json['user'] == null
          ? null
          : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$ActionLogResponseToJson(ActionLogResponse instance) =>
    <String, dynamic>{
      'ai_providers': instance.aiProviders,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'id': instance.id,
      'reason': instance.reason,
      'reporter_type': instance.reporterType,
      'review_queue_item': instance.reviewQueueItem?.toJson(),
      'target_user': instance.targetUser?.toJson(),
      'target_user_id': instance.targetUserId,
      'type': instance.type,
      'user': instance.user?.toJson(),
      'user_id': instance.userId,
    };
