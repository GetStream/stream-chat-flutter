// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelConfig _$ChannelConfigFromJson(Map<String, dynamic> json) {
  return ChannelConfig(
    automod: json['automod'] as String?,
    commands: (json['commands'] as List<dynamic>?)
        ?.map((e) => Command.fromJson(e as Map<String, dynamic>))
        .toList(),
    connectEvents: json['connect_events'] as bool?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    maxMessageLength: json['max_message_length'] as int?,
    messageRetention: json['message_retention'] as String?,
    mutes: json['mutes'] as bool?,
    name: json['name'] as String?,
    reactions: json['reactions'] as bool?,
    readEvents: json['read_events'] as bool?,
    replies: json['replies'] as bool?,
    search: json['search'] as bool?,
    typingEvents: json['typing_events'] as bool?,
    uploads: json['uploads'] as bool?,
    urlEnrichment: json['url_enrichment'] as bool?,
  );
}

Map<String, dynamic> _$ChannelConfigToJson(ChannelConfig instance) =>
    <String, dynamic>{
      'automod': instance.automod,
      'commands': instance.commands?.map((e) => e.toJson()).toList(),
      'connect_events': instance.connectEvents,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'max_message_length': instance.maxMessageLength,
      'message_retention': instance.messageRetention,
      'mutes': instance.mutes,
      'name': instance.name,
      'reactions': instance.reactions,
      'read_events': instance.readEvents,
      'replies': instance.replies,
      'search': instance.search,
      'typing_events': instance.typingEvents,
      'uploads': instance.uploads,
      'url_enrichment': instance.urlEnrichment,
    };
