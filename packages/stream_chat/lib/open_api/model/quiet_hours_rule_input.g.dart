// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiet_hours_rule_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuietHoursRuleInput _$QuietHoursRuleInputFromJson(Map<String, dynamic> json) => QuietHoursRuleInput(
  days: (json['days'] as List<dynamic>?)?.map((e) => e as QuietHoursRuleInputDays).toList(),
  end: json['end'] as String,
  start: json['start'] as String,
);

Map<String, dynamic> _$QuietHoursRuleInputToJson(
  QuietHoursRuleInput instance,
) => <String, dynamic>{
  'days': instance.days,
  'end': instance.end,
  'start': instance.start,
};
