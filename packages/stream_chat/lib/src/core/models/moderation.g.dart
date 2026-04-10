// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Moderation _$ModerationFromJson(Map<String, dynamic> json) => Moderation(
  action: ModerationAction.fromJson(json['action'] as String),
  originalText: json['original_text'] as String,
  textHarms: (json['text_harms'] as List<dynamic>?)?.map((e) => e as String).toList(),
  imageHarms: (json['image_harms'] as List<dynamic>?)?.map((e) => e as String).toList(),
  blocklistMatched: json['blocklist_matched'] as String?,
  semanticFilterMatched: json['semantic_filter_matched'] as String?,
  platformCircumvented: json['platform_circumvented'] as bool? ?? false,
);

Map<String, dynamic> _$ModerationToJson(Moderation instance) => <String, dynamic>{
  'action': ModerationAction.toJson(instance.action),
  'original_text': instance.originalText,
  'text_harms': instance.textHarms,
  'image_harms': instance.imageHarms,
  'blocklist_matched': instance.blocklistMatched,
  'semantic_filter_matched': instance.semanticFilterMatched,
  'platform_circumvented': instance.platformCircumvented,
};
