// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/action.dart';
import 'package:stream_chat/src/models/attachment_file.dart';
import 'package:stream_chat/src/models/serialization.dart';
import 'package:uuid/uuid.dart';

part 'attachment.g.dart';

/// The class that contains the information about an attachment
@JsonSerializable(includeIfNull: false)
class Attachment {
  /// Constructor used for json serialization
  Attachment({
    String id,
    this.type,
    this.titleLink,
    String title,
    this.thumbUrl,
    this.text,
    this.pretext,
    this.ogScrapeUrl,
    this.imageUrl,
    this.footerIcon,
    this.footer,
    this.fields,
    this.fallback,
    this.color,
    this.authorName,
    this.authorLink,
    this.authorIcon,
    this.assetUrl,
    this.actions,
    this.extraData,
    this.file,
    UploadState uploadState,
  })  : id = id ?? Uuid().v4(),
        title = title ?? file?.name,
        localUri = file?.path != null ? Uri.parse(file.path) : null {
    this.uploadState = uploadState ??
        ((assetUrl != null || imageUrl != null)
            ? const UploadState.success()
            : const UploadState.preparing());
  }

  /// Create a new instance from a json
  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(
          Serialization.moveToExtraDataFromRoot(json, topLevelFields));

  /// Create a new instance from a db data
  factory Attachment.fromData(Map<String, dynamic> json) =>
      _$AttachmentFromJson(Serialization.moveToExtraDataFromRoot(
          json, topLevelFields + dbSpecificTopLevelFields));

  ///The attachment type based on the URL resource. This can be: audio,
  ///image or video
  final String type;

  ///The link to which the attachment message points to.
  final String titleLink;

  /// The attachment title
  final String title;

  /// The URL to the attached file thumbnail. You can use this to represent the
  /// attached link.
  final String thumbUrl;

  /// The attachment text. It will be displayed in the channel next to the
  /// original message.
  final String text;

  /// Optional text that appears above the attachment block
  final String pretext;

  /// The original URL that was used to scrape this attachment.
  final String ogScrapeUrl;

  /// The URL to the attached image. This is present for URL pointing to an
  /// image article (eg. Unsplash)
  final String imageUrl;
  final String footerIcon;
  final String footer;
  final dynamic fields;
  final String fallback;
  final String color;

  /// The name of the author.
  final String authorName;
  final String authorLink;
  final String authorIcon;

  /// The URL to the audio, video or image related to the URL.
  final String assetUrl;

  /// Actions from a command
  final List<Action> actions;

  final Uri localUri;

  /// The file present inside this attachment.
  final AttachmentFile file;

  /// The current upload state of the attachment
  UploadState uploadState;

  /// Map of custom channel extraData
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  /// The attachment ID.
  ///
  /// This is created locally for uniquely identifying a attachment.
  final String id;

  /// Known top level fields.
  /// Useful for [Serialization] methods.
  static const topLevelFields = [
    'type',
    'title_link',
    'title',
    'thumb_url',
    'text',
    'pretext',
    'og_scrape_url',
    'image_url',
    'footer_icon',
    'footer',
    'fields',
    'fallback',
    'color',
    'author_name',
    'author_link',
    'author_icon',
    'asset_url',
    'actions',
  ];

  /// Known db specific top level fields.
  /// Useful for [Serialization] methods.
  static const dbSpecificTopLevelFields = [
    'id',
    'upload_state',
    'file',
  ];

  /// Serialize to json
  Map<String, dynamic> toJson() => Serialization.moveFromExtraDataToRoot(
      _$AttachmentToJson(this), topLevelFields)
    ..removeWhere((key, value) => dbSpecificTopLevelFields.contains(key));

  /// Serialize to db data
  Map<String, dynamic> toData() => Serialization.moveFromExtraDataToRoot(
      _$AttachmentToJson(this), topLevelFields + dbSpecificTopLevelFields);

  Attachment copyWith({
    String id,
    String type,
    String titleLink,
    String title,
    String thumbUrl,
    String text,
    String pretext,
    String ogScrapeUrl,
    String imageUrl,
    String footerIcon,
    String footer,
    dynamic fields,
    String fallback,
    String color,
    String authorName,
    String authorLink,
    String authorIcon,
    String assetUrl,
    List<Action> actions,
    AttachmentFile file,
    UploadState uploadState,
    Map<String, dynamic> extraData,
  }) =>
      Attachment(
        id: id ?? this.id,
        type: type ?? this.type,
        titleLink: titleLink ?? this.titleLink,
        title: title ?? this.title,
        thumbUrl: thumbUrl ?? this.thumbUrl,
        text: text ?? this.text,
        pretext: pretext ?? this.pretext,
        ogScrapeUrl: ogScrapeUrl ?? this.ogScrapeUrl,
        imageUrl: imageUrl ?? this.imageUrl,
        footerIcon: footerIcon ?? this.footerIcon,
        footer: footer ?? this.footer,
        fields: fields ?? this.fields,
        fallback: fallback ?? this.fallback,
        color: color ?? this.color,
        authorName: authorName ?? this.authorName,
        authorLink: authorLink ?? this.authorLink,
        authorIcon: authorIcon ?? this.authorIcon,
        assetUrl: assetUrl ?? this.assetUrl,
        actions: actions ?? this.actions,
        file: file ?? this.file,
        uploadState: uploadState ?? this.uploadState,
        extraData: extraData ?? this.extraData,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attachment &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          titleLink == other.titleLink &&
          title == other.title &&
          thumbUrl == other.thumbUrl &&
          text == other.text &&
          pretext == other.pretext &&
          ogScrapeUrl == other.ogScrapeUrl &&
          imageUrl == other.imageUrl &&
          footerIcon == other.footerIcon &&
          footer == other.footer &&
          fields == other.fields &&
          fallback == other.fallback &&
          color == other.color &&
          authorName == other.authorName &&
          authorLink == other.authorLink &&
          authorIcon == other.authorIcon &&
          assetUrl == other.assetUrl &&
          actions == other.actions &&
          extraData == other.extraData;

  @override
  int get hashCode =>
      type.hashCode ^
      titleLink.hashCode ^
      title.hashCode ^
      thumbUrl.hashCode ^
      text.hashCode ^
      pretext.hashCode ^
      ogScrapeUrl.hashCode ^
      imageUrl.hashCode ^
      footerIcon.hashCode ^
      footer.hashCode ^
      fields.hashCode ^
      fallback.hashCode ^
      color.hashCode ^
      authorName.hashCode ^
      authorLink.hashCode ^
      authorIcon.hashCode ^
      assetUrl.hashCode ^
      actions.hashCode ^
      extraData.hashCode;
}
