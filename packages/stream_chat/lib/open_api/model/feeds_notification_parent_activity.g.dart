// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_notification_parent_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsNotificationParentActivity _$FeedsNotificationParentActivityFromJson(
  Map<String, dynamic> json,
) => FeedsNotificationParentActivity(
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
      .toList(),
  id: json['id'] as String,
  text: json['text'] as String?,
  type: json['type'] as String?,
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$FeedsNotificationParentActivityToJson(
  FeedsNotificationParentActivity instance,
) => <String, dynamic>{
  'attachments': instance.attachments?.map((e) => e.toJson()).toList(),
  'id': instance.id,
  'text': instance.text,
  'type': instance.type,
  'user_id': instance.userId,
};
