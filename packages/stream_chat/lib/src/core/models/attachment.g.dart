// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
  id: json['id'] as String?,
  type: AttachmentType.fromJson(json['type'] as String?),
  titleLink: json['title_link'] as String?,
  title: json['title'] as String?,
  thumbUrl: json['thumb_url'] as String?,
  text: json['text'] as String?,
  pretext: json['pretext'] as String?,
  ogScrapeUrl: json['og_scrape_url'] as String?,
  imageUrl: json['image_url'] as String?,
  footerIcon: json['footer_icon'] as String?,
  footer: json['footer'] as String?,
  fields: json['fields'],
  fallback: json['fallback'] as String?,
  color: json['color'] as String?,
  authorName: json['author_name'] as String?,
  authorLink: json['author_link'] as String?,
  authorIcon: json['author_icon'] as String?,
  assetUrl: json['asset_url'] as String?,
  actions:
      (json['actions'] as List<dynamic>?)?.map((e) => Action.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
  originalWidth: (json['original_width'] as num?)?.toInt(),
  originalHeight: (json['original_height'] as num?)?.toInt(),
  extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
  file: json['file'] == null ? null : AttachmentFile.fromJson(json['file'] as Map<String, dynamic>),
  uploadState: json['upload_state'] == null
      ? const UploadState.success()
      : UploadState.fromJson(json['upload_state'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AttachmentToJson(Attachment instance) => <String, dynamic>{
  'type': ?AttachmentType.toJson(instance.type),
  'title_link': ?instance.titleLink,
  'title': ?instance.title,
  'thumb_url': ?instance.thumbUrl,
  'text': ?instance.text,
  'pretext': ?instance.pretext,
  'og_scrape_url': ?instance.ogScrapeUrl,
  'image_url': ?instance.imageUrl,
  'footer_icon': ?instance.footerIcon,
  'footer': ?instance.footer,
  'fields': ?instance.fields,
  'fallback': ?instance.fallback,
  'color': ?instance.color,
  'author_name': ?instance.authorName,
  'author_link': ?instance.authorLink,
  'author_icon': ?instance.authorIcon,
  'asset_url': ?instance.assetUrl,
  'actions': ?instance.actions?.map((e) => e.toJson()).toList(),
  'original_width': ?instance.originalWidth,
  'original_height': ?instance.originalHeight,
  'file': ?instance.file?.toJson(),
  'upload_state': instance.uploadState.toJson(),
  'extra_data': instance.extraData,
  'id': instance.id,
};
