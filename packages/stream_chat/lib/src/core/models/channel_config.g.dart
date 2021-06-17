// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelConfig _$ChannelConfigFromJson(Map<String, dynamic> json) {
  return ChannelConfig(
    automod: json['automod'] as String? ?? 'flag',
    commands: (json['commands'] as List<dynamic>?)
            ?.map((e) => Command.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    connectEvents: json['connect_events'] as bool? ?? false,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    maxMessageLength: json['max_message_length'] as int? ?? 0,
    messageRetention: json['message_retention'] as String? ?? '',
    mutes: json['mutes'] as bool? ?? false,
    reactions: json['reactions'] as bool? ?? false,
    readEvents: json['read_events'] as bool? ?? false,
    replies: json['replies'] as bool? ?? false,
    search: json['search'] as bool? ?? false,
    typingEvents: json['typing_events'] as bool? ?? false,
    uploads: json['uploads'] as bool? ?? false,
    urlEnrichment: json['url_enrichment'] as bool? ?? false,
  );
}
