// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_reminders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryRemindersResponse _$QueryRemindersResponseFromJson(
  Map<String, dynamic> json,
) => QueryRemindersResponse(
  duration: json['duration'] as String,
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  reminders: (json['reminders'] as List<dynamic>)
      .map((e) => ReminderResponseData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QueryRemindersResponseToJson(
  QueryRemindersResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'next': instance.next,
  'prev': instance.prev,
  'reminders': instance.reminders.map((e) => e.toJson()).toList(),
};
