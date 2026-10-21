// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_config_with_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelConfigWithInfo _$ChannelConfigWithInfoFromJson(
  Map<String, dynamic> json,
) => ChannelConfigWithInfo(
  allowedFlagReasons: (json['allowed_flag_reasons'] as List<dynamic>?)?.map((e) => e as String).toList(),
  automod: ChannelConfigWithInfoAutomod.fromJson(json['automod'] as String),
  automodBehavior: ChannelConfigWithInfoAutomodBehavior.fromJson(
    json['automod_behavior'] as String,
  ),
  automodThresholds: json['automod_thresholds'] == null
      ? null
      : Thresholds.fromJson(json['automod_thresholds'] as Map<String, dynamic>),
  blocklist: json['blocklist'] as String?,
  blocklistBehavior: json['blocklist_behavior'] == null
      ? null
      : ChannelConfigWithInfoBlocklistBehavior.fromJson(
          json['blocklist_behavior'] as String,
        ),
  blocklists: (json['blocklists'] as List<dynamic>?)
      ?.map((e) => BlockListOptions.fromJson(e as Map<String, dynamic>))
      .toList(),
  chatPreferences: json['chat_preferences'] == null
      ? null
      : ChatPreferences.fromJson(
          json['chat_preferences'] as Map<String, dynamic>,
        ),
  commands: (json['commands'] as List<dynamic>).map((e) => Command.fromJson(e as Map<String, dynamic>)).toList(),
  connectEvents: json['connect_events'] as bool,
  countMessages: json['count_messages'] as bool,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  customEvents: json['custom_events'] as bool,
  deliveryEvents: json['delivery_events'] as bool,
  grants: (json['grants'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
  markMessagesPending: json['mark_messages_pending'] as bool,
  maxMessageLength: (json['max_message_length'] as num).toInt(),
  messageRetention: json['message_retention'] as String,
  mutes: json['mutes'] as bool,
  name: json['name'] as String,
  partitionSize: (json['partition_size'] as num?)?.toInt(),
  partitionTtl: json['partition_ttl'] as String?,
  polls: json['polls'] as bool,
  pushLevel: json['push_level'] == null ? null : ChannelConfigWithInfoPushLevel.fromJson(json['push_level'] as String),
  pushNotifications: json['push_notifications'] as bool,
  quotes: json['quotes'] as bool,
  reactions: json['reactions'] as bool,
  readEvents: json['read_events'] as bool,
  reminders: json['reminders'] as bool,
  replies: json['replies'] as bool,
  search: json['search'] as bool,
  sharedLocations: json['shared_locations'] as bool,
  skipLastMsgUpdateForSystemMsgs: json['skip_last_msg_update_for_system_msgs'] as bool,
  typingEvents: json['typing_events'] as bool,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  uploads: json['uploads'] as bool,
  urlEnrichment: json['url_enrichment'] as bool,
  userMessageReminders: json['user_message_reminders'] as bool,
);

Map<String, dynamic> _$ChannelConfigWithInfoToJson(
  ChannelConfigWithInfo instance,
) => <String, dynamic>{
  'allowed_flag_reasons': instance.allowedFlagReasons,
  'automod': instance.automod.toJson(),
  'automod_behavior': instance.automodBehavior.toJson(),
  'automod_thresholds': instance.automodThresholds?.toJson(),
  'blocklist': instance.blocklist,
  'blocklist_behavior': instance.blocklistBehavior?.toJson(),
  'blocklists': instance.blocklists?.map((e) => e.toJson()).toList(),
  'chat_preferences': instance.chatPreferences?.toJson(),
  'commands': instance.commands.map((e) => e.toJson()).toList(),
  'connect_events': instance.connectEvents,
  'count_messages': instance.countMessages,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom_events': instance.customEvents,
  'delivery_events': instance.deliveryEvents,
  'grants': instance.grants,
  'mark_messages_pending': instance.markMessagesPending,
  'max_message_length': instance.maxMessageLength,
  'message_retention': instance.messageRetention,
  'mutes': instance.mutes,
  'name': instance.name,
  'partition_size': instance.partitionSize,
  'partition_ttl': instance.partitionTtl,
  'polls': instance.polls,
  'push_level': instance.pushLevel?.toJson(),
  'push_notifications': instance.pushNotifications,
  'quotes': instance.quotes,
  'reactions': instance.reactions,
  'read_events': instance.readEvents,
  'reminders': instance.reminders,
  'replies': instance.replies,
  'search': instance.search,
  'shared_locations': instance.sharedLocations,
  'skip_last_msg_update_for_system_msgs': instance.skipLastMsgUpdateForSystemMsgs,
  'typing_events': instance.typingEvents,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'uploads': instance.uploads,
  'url_enrichment': instance.urlEnrichment,
  'user_message_reminders': instance.userMessageReminders,
};
