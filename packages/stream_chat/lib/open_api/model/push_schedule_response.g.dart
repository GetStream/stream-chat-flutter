// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_schedule_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushScheduleResponse _$PushScheduleResponseFromJson(
  Map<String, dynamic> json,
) => PushScheduleResponse(
  quietHours: (json['quiet_hours'] as List<dynamic>)
      .map((e) => QuietHoursRuleResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  timezone: json['timezone'] as String,
);

Map<String, dynamic> _$PushScheduleResponseToJson(
  PushScheduleResponse instance,
) => <String, dynamic>{
  'quiet_hours': instance.quietHours.map((e) => e.toJson()).toList(),
  'timezone': instance.timezone,
};
