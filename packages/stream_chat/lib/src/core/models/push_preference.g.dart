// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PushPreferenceInputToJson(
  PushPreferenceInput instance,
) => <String, dynamic>{
  'channel_cid': ?instance.channelCid,
  'call_level': ?instance.callLevel,
  'chat_level': ?instance.chatLevel,
  'chat_preferences': ?instance.chatPreferences?.toJson(),
  'disabled_until': ?instance.disabledUntil?.toIso8601String(),
  'remove_disable': ?instance.removeDisable,
  'schedule': ?instance.schedule?.toJson(),
  'remove_schedule': ?instance.removeSchedule,
};

PushPreference _$PushPreferenceFromJson(Map<String, dynamic> json) => PushPreference(
  callLevel: json['call_level'] as CallLevel?,
  chatLevel: json['chat_level'] as ChatLevel?,
  chatPreferences: json['chat_preferences'] == null
      ? null
      : ChatPreferences.fromJson(
          json['chat_preferences'] as Map<String, dynamic>,
        ),
  disabledUntil: json['disabled_until'] == null ? null : DateTime.parse(json['disabled_until'] as String),
  schedule: json['schedule'] == null ? null : PushSchedule.fromJson(json['schedule'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PushPreferenceToJson(PushPreference instance) => <String, dynamic>{
  'call_level': ?instance.callLevel,
  'chat_level': ?instance.chatLevel,
  'chat_preferences': ?instance.chatPreferences?.toJson(),
  'disabled_until': ?instance.disabledUntil?.toIso8601String(),
  'schedule': ?instance.schedule?.toJson(),
};

ChannelPushPreference _$ChannelPushPreferenceFromJson(
  Map<String, dynamic> json,
) => ChannelPushPreference(
  chatLevel: json['chat_level'] as ChatLevel?,
  chatPreferences: json['chat_preferences'] == null
      ? null
      : ChatPreferences.fromJson(
          json['chat_preferences'] as Map<String, dynamic>,
        ),
  disabledUntil: json['disabled_until'] == null ? null : DateTime.parse(json['disabled_until'] as String),
);

Map<String, dynamic> _$ChannelPushPreferenceToJson(
  ChannelPushPreference instance,
) => <String, dynamic>{
  'chat_level': ?instance.chatLevel,
  'chat_preferences': ?instance.chatPreferences?.toJson(),
  'disabled_until': ?instance.disabledUntil?.toIso8601String(),
};

PushSchedule _$PushScheduleFromJson(Map<String, dynamic> json) => PushSchedule(
  timezone: json['timezone'] as String,
  quietHours: (json['quiet_hours'] as List<dynamic>)
      .map((e) => QuietHoursRule.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PushScheduleToJson(PushSchedule instance) => <String, dynamic>{
  'timezone': instance.timezone,
  'quiet_hours': instance.quietHours.map((e) => e.toJson()).toList(),
};

QuietHoursRule _$QuietHoursRuleFromJson(Map<String, dynamic> json) => QuietHoursRule(
  start: json['start'] as String,
  end: json['end'] as String,
  days: (json['days'] as List<dynamic>?)?.map((e) => e as QuietHoursDay).toList() ?? [],
);

Map<String, dynamic> _$QuietHoursRuleToJson(QuietHoursRule instance) => <String, dynamic>{
  'start': instance.start,
  'end': instance.end,
  'days': instance.days,
};
