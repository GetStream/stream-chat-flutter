// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_reminder_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateReminderResponse _$UpdateReminderResponseFromJson(
  Map<String, dynamic> json,
) => UpdateReminderResponse(
  duration: json['duration'] as String,
  reminder: ReminderResponseData.fromJson(
    json['reminder'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UpdateReminderResponseToJson(
  UpdateReminderResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'reminder': instance.reminder.toJson(),
};
