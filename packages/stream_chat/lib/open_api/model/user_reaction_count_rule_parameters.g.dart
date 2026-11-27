// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_reaction_count_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReactionCountRuleParameters _$UserReactionCountRuleParametersFromJson(
  Map<String, dynamic> json,
) => UserReactionCountRuleParameters(
  count: json['count'] as String?,
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$UserReactionCountRuleParametersToJson(
  UserReactionCountRuleParameters instance,
) => <String, dynamic>{
  'count': instance.count,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
