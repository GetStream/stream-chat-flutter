// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_message_count_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelMessageCountRuleParameters _$ChannelMessageCountRuleParametersFromJson(
  Map<String, dynamic> json,
) => ChannelMessageCountRuleParameters(
  operator: json['operator'] as String?,
  threshold: (json['threshold'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChannelMessageCountRuleParametersToJson(
  ChannelMessageCountRuleParameters instance,
) => <String, dynamic>{
  'operator': instance.operator,
  'threshold': instance.threshold,
};
