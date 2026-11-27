// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intent_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntentRuleParameters _$IntentRuleParametersFromJson(
  Map<String, dynamic> json,
) => IntentRuleParameters(
  threshold: (json['threshold'] as num?)?.toInt(),
  topic: json['topic'] as String,
);

Map<String, dynamic> _$IntentRuleParametersToJson(
  IntentRuleParameters instance,
) => <String, dynamic>{
  'threshold': instance.threshold,
  'topic': instance.topic,
};
