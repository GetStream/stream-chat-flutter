// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map json) {
  return Attachment(
    id: json['id'] as String,
    type: json['type'] as String,
    titleLink: json['title_link'] as String,
    title: json['title'] as String,
    thumbUrl: json['thumb_url'] as String,
    text: json['text'] as String,
    pretext: json['pretext'] as String,
    ogScrapeUrl: json['og_scrape_url'] as String,
    imageUrl: json['image_url'] as String,
    footerIcon: json['footer_icon'] as String,
    footer: json['footer'] as String,
    fields: json['fields'],
    fallback: json['fallback'] as String,
    color: json['color'] as String,
    authorName: json['author_name'] as String,
    authorLink: json['author_link'] as String,
    authorIcon: json['author_icon'] as String,
    assetUrl: json['asset_url'] as String,
    actions: (json['actions'] as List)
        ?.map((e) => e == null
            ? null
            : Action.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    extraData: (json['extra_data'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
    file: json['file'] == null
        ? null
        : AttachmentFile.fromJson((json['file'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    uploadState: json['upload_state'] == null
        ? null
        : UploadState.fromJson((json['upload_state'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  writeNotNull('title_link', instance.titleLink);
  writeNotNull('title', instance.title);
  writeNotNull('thumb_url', instance.thumbUrl);
  writeNotNull('text', instance.text);
  writeNotNull('pretext', instance.pretext);
  writeNotNull('og_scrape_url', instance.ogScrapeUrl);
  writeNotNull('image_url', instance.imageUrl);
  writeNotNull('footer_icon', instance.footerIcon);
  writeNotNull('footer', instance.footer);
  writeNotNull('fields', instance.fields);
  writeNotNull('fallback', instance.fallback);
  writeNotNull('color', instance.color);
  writeNotNull('author_name', instance.authorName);
  writeNotNull('author_link', instance.authorLink);
  writeNotNull('author_icon', instance.authorIcon);
  writeNotNull('asset_url', instance.assetUrl);
  writeNotNull('actions', instance.actions?.map((e) => e?.toJson())?.toList());
  writeNotNull('file', instance.file?.toJson());
  writeNotNull('upload_state', instance.uploadState?.toJson());
  writeNotNull('extra_data', instance.extraData);
  writeNotNull('id', instance.id);
  return val;
}
