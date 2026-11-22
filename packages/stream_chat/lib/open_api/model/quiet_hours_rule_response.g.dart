// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiet_hours_rule_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuietHoursRuleResponse _$QuietHoursRuleResponseFromJson(
  Map<String, dynamic> json,
) => QuietHoursRuleResponse(
  days: (json['days'] as List<dynamic>?)?.map((e) => e as String).toList(),
  end: json['end'] as String,
  start: json['start'] as String,
);

Map<String, dynamic> _$QuietHoursRuleResponseToJson(
  QuietHoursRuleResponse instance,
) => <String, dynamic>{
  'days': instance.days,
  'end': instance.end,
  'start': instance.start,
};
