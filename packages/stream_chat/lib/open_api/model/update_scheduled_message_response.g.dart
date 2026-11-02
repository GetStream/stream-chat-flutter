// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_scheduled_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateScheduledMessageResponse _$UpdateScheduledMessageResponseFromJson(
  Map<String, dynamic> json,
) => UpdateScheduledMessageResponse(
  duration: json['duration'] as String,
  scheduledMessage: ScheduledMessageResponse.fromJson(
    json['scheduled_message'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UpdateScheduledMessageResponseToJson(
  UpdateScheduledMessageResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'scheduled_message': instance.scheduledMessage.toJson(),
};
