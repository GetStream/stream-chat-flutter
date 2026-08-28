// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_og_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOGResponse _$GetOGResponseFromJson(Map<String, dynamic> json) =>
    GetOGResponse(
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => Action.fromJson(e as Map<String, dynamic>))
          .toList(),
      assetUrl: json['asset_url'] as String?,
      authorIcon: json['author_icon'] as String?,
      authorLink: json['author_link'] as String?,
      authorName: json['author_name'] as String?,
      color: json['color'] as String?,
      custom: json['custom'] as Map<String, dynamic>,
      duration: json['duration'] as String,
      fallback: json['fallback'] as String?,
      fields: (json['fields'] as List<dynamic>?)
          ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList(),
      footer: json['footer'] as String?,
      footerIcon: json['footer_icon'] as String?,
      giphy: json['giphy'] == null
          ? null
          : Images.fromJson(json['giphy'] as Map<String, dynamic>),
      imageUrl: json['image_url'] as String?,
      ogScrapeUrl: json['og_scrape_url'] as String?,
      originalHeight: (json['original_height'] as num?)?.toInt(),
      originalWidth: (json['original_width'] as num?)?.toInt(),
      pretext: json['pretext'] as String?,
      text: json['text'] as String?,
      thumbUrl: json['thumb_url'] as String?,
      title: json['title'] as String?,
      titleLink: json['title_link'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$GetOGResponseToJson(GetOGResponse instance) =>
    <String, dynamic>{
      'actions': instance.actions?.map((e) => e.toJson()).toList(),
      'asset_url': instance.assetUrl,
      'author_icon': instance.authorIcon,
      'author_link': instance.authorLink,
      'author_name': instance.authorName,
      'color': instance.color,
      'custom': instance.custom,
      'duration': instance.duration,
      'fallback': instance.fallback,
      'fields': instance.fields?.map((e) => e.toJson()).toList(),
      'footer': instance.footer,
      'footer_icon': instance.footerIcon,
      'giphy': instance.giphy?.toJson(),
      'image_url': instance.imageUrl,
      'og_scrape_url': instance.ogScrapeUrl,
      'original_height': instance.originalHeight,
      'original_width': instance.originalWidth,
      'pretext': instance.pretext,
      'text': instance.text,
      'thumb_url': instance.thumbUrl,
      'title': instance.title,
      'title_link': instance.titleLink,
      'type': instance.type,
    };
