// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_notification_trigger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsNotificationTrigger _$FeedsNotificationTriggerFromJson(
  Map<String, dynamic> json,
) => FeedsNotificationTrigger(
  comment: json['comment'] == null
      ? null
      : FeedsNotificationComment.fromJson(
          json['comment'] as Map<String, dynamic>,
        ),
  custom: json['custom'] as Map<String, dynamic>?,
  text: json['text'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$FeedsNotificationTriggerToJson(
  FeedsNotificationTrigger instance,
) => <String, dynamic>{
  'comment': instance.comment?.toJson(),
  'custom': instance.custom,
  'text': instance.text,
  'type': instance.type,
};
