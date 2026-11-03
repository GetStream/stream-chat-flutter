// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelConfig _$ChannelConfigFromJson(Map<String, dynamic> json) => ChannelConfig(
  automod: json['automod'] as String? ?? 'flag',
  commands:
      (json['commands'] as List<dynamic>?)?.map((e) => Command.fromJson(e as Map<String, dynamic>)).toList() ??
      const [],
  connectEvents: json['connect_events'] as bool? ?? false,
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
  maxMessageLength: (json['max_message_length'] as num?)?.toInt() ?? 0,
  messageRetention: json['message_retention'] as String? ?? '',
  mutes: json['mutes'] as bool? ?? false,
  reactions: json['reactions'] as bool? ?? false,
  readEvents: json['read_events'] as bool? ?? false,
  replies: json['replies'] as bool? ?? false,
  search: json['search'] as bool? ?? false,
  polls: json['polls'] as bool? ?? false,
  pushLevel: json['push_level'] as PushLevel?,
  pushNotifications: json['push_notifications'] as bool? ?? true,
  chatPreferences: json['chat_preferences'] == null
      ? null
      : ChatPreferences.fromJson(
          json['chat_preferences'] as Map<String, dynamic>,
        ),
  typingEvents: json['typing_events'] as bool? ?? false,
  uploads: json['uploads'] as bool? ?? false,
  urlEnrichment: json['url_enrichment'] as bool? ?? false,
  skipLastMsgUpdateForSystemMsgs: json['skip_last_msg_update_for_system_msgs'] as bool? ?? false,
  userMessageReminders: json['user_message_reminders'] as bool? ?? false,
  markMessagesPending: json['mark_messages_pending'] as bool? ?? false,
  deliveryEvents: json['delivery_events'] as bool? ?? false,
  sharedLocations: json['shared_locations'] as bool? ?? false,
  scheduledMessagesMaxPerChannel: (json['scheduled_messages_max_per_channel'] as num?)?.toInt(),
  scheduledMessagesMaxPerUser: (json['scheduled_messages_max_per_user'] as num?)?.toInt(),
  scheduledMessagesMinLeadTime: _$JsonConverterFromJson<num, Duration>(
    json['scheduled_messages_min_lead_time_seconds'],
    const DurationInSecondsConverter().fromJson,
  ),
  scheduledMessagesMaxLeadTime: _$JsonConverterFromJson<num, Duration>(
    json['scheduled_messages_max_lead_time_seconds'],
    const DurationInSecondsConverter().fromJson,
  ),
);

Map<String, dynamic> _$ChannelConfigToJson(ChannelConfig instance) => <String, dynamic>{
  'automod': instance.automod,
  'commands': instance.commands.map((e) => e.toJson()).toList(),
  'connect_events': instance.connectEvents,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'max_message_length': instance.maxMessageLength,
  'message_retention': instance.messageRetention,
  'mutes': instance.mutes,
  'reactions': instance.reactions,
  'read_events': instance.readEvents,
  'replies': instance.replies,
  'search': instance.search,
  'polls': instance.polls,
  'push_level': instance.pushLevel,
  'push_notifications': instance.pushNotifications,
  'chat_preferences': instance.chatPreferences?.toJson(),
  'typing_events': instance.typingEvents,
  'uploads': instance.uploads,
  'url_enrichment': instance.urlEnrichment,
  'skip_last_msg_update_for_system_msgs': instance.skipLastMsgUpdateForSystemMsgs,
  'user_message_reminders': instance.userMessageReminders,
  'mark_messages_pending': instance.markMessagesPending,
  'delivery_events': instance.deliveryEvents,
  'shared_locations': instance.sharedLocations,
  'scheduled_messages_max_per_channel': instance.scheduledMessagesMaxPerChannel,
  'scheduled_messages_max_per_user': instance.scheduledMessagesMaxPerUser,
  'scheduled_messages_min_lead_time_seconds': _$JsonConverterToJson<num, Duration>(
    instance.scheduledMessagesMinLeadTime,
    const DurationInSecondsConverter().toJson,
  ),
  'scheduled_messages_max_lead_time_seconds': _$JsonConverterToJson<num, Duration>(
    instance.scheduledMessagesMaxLeadTime,
    const DurationInSecondsConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
