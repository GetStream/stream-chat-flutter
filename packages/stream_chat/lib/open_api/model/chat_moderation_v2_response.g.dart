// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_moderation_v2_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModerationV2Response _$ChatModerationV2ResponseFromJson(
  Map<String, dynamic> json,
) => ChatModerationV2Response(
  action: json['action'] as String,
  blocklistMatched: json['blocklist_matched'] as String?,
  blocklistsMatched: (json['blocklists_matched'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  imageHarms: (json['image_harms'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  originalText: json['original_text'] as String,
  platformCircumvented: json['platform_circumvented'] as bool?,
  semanticFilterMatched: json['semantic_filter_matched'] as String?,
  textHarms: (json['text_harms'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ChatModerationV2ResponseToJson(
  ChatModerationV2Response instance,
) => <String, dynamic>{
  'action': instance.action,
  'blocklist_matched': instance.blocklistMatched,
  'blocklists_matched': instance.blocklistsMatched,
  'image_harms': instance.imageHarms,
  'original_text': instance.originalText,
  'platform_circumvented': instance.platformCircumvented,
  'semantic_filter_matched': instance.semanticFilterMatched,
  'text_harms': instance.textHarms,
};
