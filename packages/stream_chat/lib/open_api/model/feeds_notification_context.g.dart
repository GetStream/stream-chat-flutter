// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_notification_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsNotificationContext _$FeedsNotificationContextFromJson(
  Map<String, dynamic> json,
) => FeedsNotificationContext(
  target: json['target'] == null
      ? null
      : FeedsNotificationTarget.fromJson(
          json['target'] as Map<String, dynamic>,
        ),
  trigger: json['trigger'] == null
      ? null
      : FeedsNotificationTrigger.fromJson(
          json['trigger'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$FeedsNotificationContextToJson(
  FeedsNotificationContext instance,
) => <String, dynamic>{
  'target': instance.target?.toJson(),
  'trigger': instance.trigger?.toJson(),
};
