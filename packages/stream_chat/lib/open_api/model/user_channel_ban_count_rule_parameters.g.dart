// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_channel_ban_count_rule_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserChannelBanCountRuleParameters _$UserChannelBanCountRuleParametersFromJson(
  Map<String, dynamic> json,
) => UserChannelBanCountRuleParameters(
  bannedBy: json['banned_by'] as String?,
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$UserChannelBanCountRuleParametersToJson(
  UserChannelBanCountRuleParameters instance,
) => <String, dynamic>{
  'banned_by': instance.bannedBy,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
