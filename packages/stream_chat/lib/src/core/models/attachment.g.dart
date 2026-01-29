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
  if (AttachmentType.toJson(instance.type) case final value?) 'type': value,
  if (instance.titleLink case final value?) 'title_link': value,
  if (instance.title case final value?) 'title': value,
  if (instance.thumbUrl case final value?) 'thumb_url': value,
  if (instance.text case final value?) 'text': value,
  if (instance.pretext case final value?) 'pretext': value,
  if (instance.ogScrapeUrl case final value?) 'og_scrape_url': value,
  if (instance.imageUrl case final value?) 'image_url': value,
  if (instance.footerIcon case final value?) 'footer_icon': value,
  if (instance.footer case final value?) 'footer': value,
  if (instance.fields case final value?) 'fields': value,
  if (instance.fallback case final value?) 'fallback': value,
  if (instance.color case final value?) 'color': value,
  if (instance.authorName case final value?) 'author_name': value,
  if (instance.authorLink case final value?) 'author_link': value,
  if (instance.authorIcon case final value?) 'author_icon': value,
  if (instance.assetUrl case final value?) 'asset_url': value,
  if (instance.actions?.map((e) => e.toJson()).toList() case final value?) 'actions': value,
  if (instance.originalWidth case final value?) 'original_width': value,
  if (instance.originalHeight case final value?) 'original_height': value,
  if (instance.file?.toJson() case final value?) 'file': value,
  'upload_state': instance.uploadState.toJson(),
  'extra_data': instance.extraData,
  'id': instance.id,
};
