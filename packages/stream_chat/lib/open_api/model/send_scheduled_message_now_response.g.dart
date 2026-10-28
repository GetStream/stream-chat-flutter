// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_scheduled_message_now_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendScheduledMessageNowResponse _$SendScheduledMessageNowResponseFromJson(
  Map<String, dynamic> json,
) => SendScheduledMessageNowResponse(
  duration: json['duration'] as String,
  scheduledMessage: ScheduledMessageResponse.fromJson(
    json['scheduled_message'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SendScheduledMessageNowResponseToJson(
  SendScheduledMessageNowResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'scheduled_message': instance.scheduledMessage.toJson(),
};
