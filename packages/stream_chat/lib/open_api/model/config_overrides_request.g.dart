// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_overrides_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigOverridesRequest _$ConfigOverridesRequestFromJson(
  Map<String, dynamic> json,
) => ConfigOverridesRequest(
  blocklist: json['blocklist'] as String?,
  blocklistBehavior: json['blocklist_behavior'] == null
      ? null
      : ConfigOverridesRequestBlocklistBehavior.fromJson(
          json['blocklist_behavior'] as String,
        ),
  chatPreferences: json['chat_preferences'] == null
      ? null
      : ChatPreferences.fromJson(
          json['chat_preferences'] as Map<String, dynamic>,
        ),
  commands: (json['commands'] as List<dynamic>?)?.map((e) => e as String).toList(),
  countMessages: json['count_messages'] as bool?,
  grants: (json['grants'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
  maxMessageLength: (json['max_message_length'] as num?)?.toInt(),
  pushLevel: json['push_level'] == null ? null : ConfigOverridesRequestPushLevel.fromJson(json['push_level'] as String),
  quotes: json['quotes'] as bool?,
  reactions: json['reactions'] as bool?,
  replies: json['replies'] as bool?,
  sharedLocations: json['shared_locations'] as bool?,
  typingEvents: json['typing_events'] as bool?,
  uploads: json['uploads'] as bool?,
  urlEnrichment: json['url_enrichment'] as bool?,
  userMessageReminders: json['user_message_reminders'] as bool?,
);

Map<String, dynamic> _$ConfigOverridesRequestToJson(
  ConfigOverridesRequest instance,
) => <String, dynamic>{
  'blocklist': instance.blocklist,
  'blocklist_behavior': instance.blocklistBehavior?.toJson(),
  'chat_preferences': instance.chatPreferences?.toJson(),
  'commands': instance.commands,
  'count_messages': instance.countMessages,
  'grants': instance.grants,
  'max_message_length': instance.maxMessageLength,
  'push_level': instance.pushLevel?.toJson(),
  'quotes': instance.quotes,
  'reactions': instance.reactions,
  'replies': instance.replies,
  'shared_locations': instance.sharedLocations,
  'typing_events': instance.typingEvents,
  'uploads': instance.uploads,
  'url_enrichment': instance.urlEnrichment,
  'user_message_reminders': instance.userMessageReminders,
};
