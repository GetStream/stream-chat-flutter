// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_scheduled_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteScheduledMessageResponse _$DeleteScheduledMessageResponseFromJson(
  Map<String, dynamic> json,
) => DeleteScheduledMessageResponse(
  duration: json['duration'] as String,
  scheduledMessage: ScheduledMessageResponse.fromJson(
    json['scheduled_message'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DeleteScheduledMessageResponseToJson(
  DeleteScheduledMessageResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'scheduled_message': instance.scheduledMessage.toJson(),
};
