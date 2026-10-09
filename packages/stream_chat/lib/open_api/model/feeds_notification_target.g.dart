// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_notification_target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsNotificationTarget _$FeedsNotificationTargetFromJson(
  Map<String, dynamic> json,
) => FeedsNotificationTarget(
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
      .toList(),
  comment: json['comment'] == null
      ? null
      : FeedsNotificationComment.fromJson(
          json['comment'] as Map<String, dynamic>,
        ),
  custom: json['custom'] as Map<String, dynamic>?,
  id: json['id'] as String,
  name: json['name'] as String?,
  parentActivity: json['parent_activity'] == null
      ? null
      : FeedsNotificationParentActivity.fromJson(
          json['parent_activity'] as Map<String, dynamic>,
        ),
  text: json['text'] as String?,
  type: json['type'] as String?,
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$FeedsNotificationTargetToJson(
  FeedsNotificationTarget instance,
) => <String, dynamic>{
  'attachments': instance.attachments?.map((e) => e.toJson()).toList(),
  'comment': instance.comment?.toJson(),
  'custom': instance.custom,
  'id': instance.id,
  'name': instance.name,
  'parent_activity': instance.parentActivity?.toJson(),
  'text': instance.text,
  'type': instance.type,
  'user_id': instance.userId,
};
