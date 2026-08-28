// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_rule_action_sequence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRuleActionSequence _$CallRuleActionSequenceFromJson(
  Map<String, dynamic> json,
) => CallRuleActionSequence(
  actions: (json['actions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  callOptions: json['call_options'] == null
      ? null
      : CallActionOptions.fromJson(
          json['call_options'] as Map<String, dynamic>,
        ),
  violationNumber: (json['violation_number'] as num?)?.toInt(),
);

Map<String, dynamic> _$CallRuleActionSequenceToJson(
  CallRuleActionSequence instance,
) => <String, dynamic>{
  'actions': instance.actions,
  'call_options': instance.callOptions?.toJson(),
  'violation_number': instance.violationNumber,
};
