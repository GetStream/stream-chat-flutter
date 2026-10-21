// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_payload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationPayloadResponse _$ModerationPayloadResponseFromJson(
  Map<String, dynamic> json,
) => ModerationPayloadResponse(
  audios: (json['audios'] as List<dynamic>?)?.map((e) => e as String).toList(),
  custom: json['custom'] as Map<String, dynamic>?,
  imageIds: (json['image_ids'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  imageOrderedKeys: (json['image_ordered_keys'] as List<dynamic>?)?.map((e) => e as String).toList(),
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  otherMedia: (json['other_media'] as List<dynamic>?)?.map((e) => e as String).toList(),
  textIds: (json['text_ids'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  textOrderedKeys: (json['text_ordered_keys'] as List<dynamic>?)?.map((e) => e as String).toList(),
  texts: (json['texts'] as List<dynamic>?)?.map((e) => e as String).toList(),
  videos: (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$ModerationPayloadResponseToJson(
  ModerationPayloadResponse instance,
) => <String, dynamic>{
  'audios': instance.audios,
  'custom': instance.custom,
  'image_ids': instance.imageIds,
  'image_ordered_keys': instance.imageOrderedKeys,
  'images': instance.images,
  'other_media': instance.otherMedia,
  'text_ids': instance.textIds,
  'text_ordered_keys': instance.textOrderedKeys,
  'texts': instance.texts,
  'videos': instance.videos,
};
