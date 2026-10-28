// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledMessageResponse _$ScheduledMessageResponseFromJson(
  Map<String, dynamic> json,
) => ScheduledMessageResponse(
  channel: json['channel'] == null
      ? null
      : ScheduledMessageChannelResponse.fromJson(
          json['channel'] as Map<String, dynamic>,
        ),
  cid: json['cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  failureReason: json['failure_reason'] == null
      ? null
      : ScheduledMessageFailureReason.fromJson(
          json['failure_reason'] as String,
        ),
  id: json['id'] as String,
  message: ScheduledMessageContentResponse.fromJson(
    json['message'] as Map<String, dynamic>,
  ),
  scheduledAt: const StreamDateTimeConverter().fromJson(
    json['scheduled_at'] as Object,
  ),
  status: ScheduledMessageStatus.fromJson(json['status'] as String),
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduledMessageResponseToJson(
  ScheduledMessageResponse instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'failure_reason': instance.failureReason?.toJson(),
  'id': instance.id,
  'message': instance.message.toJson(),
  'scheduled_at': const StreamDateTimeConverter().toJson(instance.scheduledAt),
  'status': instance.status.toJson(),
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user.toJson(),
};
