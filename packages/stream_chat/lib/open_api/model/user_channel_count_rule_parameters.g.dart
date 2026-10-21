// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_channel_count_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserChannelCountRuleParameters _$UserChannelCountRuleParametersFromJson(
  Map<String, dynamic> json,
) => UserChannelCountRuleParameters(
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$UserChannelCountRuleParametersToJson(
  UserChannelCountRuleParameters instance,
) => <String, dynamic>{
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
