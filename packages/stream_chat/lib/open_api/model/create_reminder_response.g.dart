// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reminder_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReminderResponse _$CreateReminderResponseFromJson(
  Map<String, dynamic> json,
) => CreateReminderResponse(
  duration: json['duration'] as String,
  reminder: ReminderResponseData.fromJson(
    json['reminder'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CreateReminderResponseToJson(
  CreateReminderResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'reminder': instance.reminder.toJson(),
};
