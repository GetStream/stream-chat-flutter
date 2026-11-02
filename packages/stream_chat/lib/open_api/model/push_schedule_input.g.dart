// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_schedule_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushScheduleInput _$PushScheduleInputFromJson(Map<String, dynamic> json) => PushScheduleInput(
  quietHours: (json['quiet_hours'] as List<dynamic>?)
      ?.map((e) => QuietHoursRuleInput.fromJson(e as Map<String, dynamic>))
      .toList(),
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$PushScheduleInputToJson(PushScheduleInput instance) => <String, dynamic>{
  'quiet_hours': instance.quietHours?.map((e) => e.toJson()).toList(),
  'timezone': instance.timezone,
};
