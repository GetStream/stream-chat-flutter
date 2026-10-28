// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiet_hours_rule_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuietHoursRuleInput _$QuietHoursRuleInputFromJson(Map<String, dynamic> json) => QuietHoursRuleInput(
  days: (json['days'] as List<dynamic>?)?.map((e) => QuietHoursRuleInputDays.fromJson(e as String)).toList(),
  end: json['end'] as String,
  start: json['start'] as String,
);

Map<String, dynamic> _$QuietHoursRuleInputToJson(
  QuietHoursRuleInput instance,
) => <String, dynamic>{
  'days': instance.days?.map((e) => e.toJson()).toList(),
  'end': instance.end,
  'start': instance.start,
};
