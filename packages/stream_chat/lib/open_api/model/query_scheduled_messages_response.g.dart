// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_scheduled_messages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryScheduledMessagesResponse _$QueryScheduledMessagesResponseFromJson(
  Map<String, dynamic> json,
) => QueryScheduledMessagesResponse(
  duration: json['duration'] as String,
  next: json['next'] as String?,
  scheduledMessages: (json['scheduled_messages'] as List<dynamic>)
      .map((e) => ScheduledMessageResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QueryScheduledMessagesResponseToJson(
  QueryScheduledMessagesResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'next': instance.next,
  'scheduled_messages': instance.scheduledMessages.map((e) => e.toJson()).toList(),
};
