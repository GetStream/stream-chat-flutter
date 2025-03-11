// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/models/action.dart';
import 'package:stream_chat/src/core/models/attachment_file.dart';
import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:uuid/uuid.dart';

part 'attachment.g.dart';

/// The class that contains the information about an attachment
@JsonSerializable(includeIfNull: false)
class Attachment extends Equatable {
  /// Constructor used for json serialization
  Attachment({
    String? id,
    String? type,
    this.titleLink,
    String? title,
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
    this.actions = const [],
    this.originalWidth,
    this.originalHeight,
    Map<String, Object?> extraData = const {},
    this.file,
    this.uploadState = const UploadState.preparing(),
  })  : id = id ?? const Uuid().v4(),
        _type = switch (type) {
          String() => AttachmentType(type),
          _ => null,
        },
        title = title ?? file?.name,
        localUri = file?.path != null ? Uri.parse(file!.path!) : null,
        // For backwards compatibility,
        // set 'file_size', 'mime_type' in [extraData].
        extraData = {
          ...extraData,
          if (file?.size != null) 'file_size': file?.size,
          if (file?.mediaType != null) 'mime_type': file?.mediaType?.mimeType,
        };

  /// Create a new instance from a json
  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(
        Serializer.moveToExtraDataFromRoot(json, topLevelFields),
      );

  /// Create a new instance from a db data
  factory Attachment.fromData(Map<String, dynamic> json) =>
      _$AttachmentFromJson(Serializer.moveToExtraDataFromRoot(
        json,
        topLevelFields + dbSpecificTopLevelFields,
      ));

  factory Attachment.fromOGAttachment(OGAttachmentResponse ogAttachment) =>
      Attachment(
        // If the type is not specified, we default to urlPreview.
        type: ogAttachment.type ?? AttachmentType.urlPreview,
        title: ogAttachment.title,
        titleLink: ogAttachment.titleLink,
        text: ogAttachment.text,
        imageUrl: ogAttachment.imageUrl,
        thumbUrl: ogAttachment.thumbUrl,
        authorName: ogAttachment.authorName,
        authorLink: ogAttachment.authorLink,
        assetUrl: ogAttachment.assetUrl,
        ogScrapeUrl: ogAttachment.ogScrapeUrl,
        uploadState: const UploadState.success(),
      );

  ///The attachment type based on the URL resource. This can be: audio,
  ///image or video
  @JsonKey(
    includeIfNull: false,
    toJson: AttachmentType.toJson,
    fromJson: AttachmentType.fromJson,
  )
  AttachmentType? get type {
    // If the attachment contains ogScrapeUrl as well as titleLink, we consider
    // it as a urlPreview.
    if (ogScrapeUrl != null && titleLink != null) {
      return AttachmentType.urlPreview;
    }

    return _type;
  }

  final AttachmentType? _type;

  /// The raw attachment type.
  String? get rawType => _type;

  ///The link to which the attachment message points to.
  final String? titleLink;

  /// The attachment title
  final String? title;

  /// The URL to the attached file thumbnail. You can use this to represent the
  /// attached link.
  final String? thumbUrl;

  /// The attachment text. It will be displayed in the channel next to the
  /// original message.
  final String? text;

  /// Optional text that appears above the attachment block
  final String? pretext;

  /// The original URL that was used to scrape this attachment.
  final String? ogScrapeUrl;

  /// The URL to the attached image. This is present for URL pointing to an
  /// image article (eg. Unsplash)
  final String? imageUrl;
  final String? footerIcon;
  final String? footer;
  final dynamic fields;
  final String? fallback;
  final String? color;

  /// The name of the author.
  final String? authorName;
  final String? authorLink;
  final String? authorIcon;

  /// The URL to the audio, video or image related to the URL.
  final String? assetUrl;

  /// Actions from a command
  final List<Action>? actions;

  /// The original width of the attached image.
  final int? originalWidth;

  /// The original height of the attached image.
  final int? originalHeight;

  final Uri? localUri;

  /// The file present inside this attachment.
  final AttachmentFile? file;

  /// The current upload state of the attachment
  @JsonKey(defaultValue: UploadState.success)
  final UploadState uploadState;

  /// Map of custom channel extraData
  final Map<String, Object?> extraData;

  /// The attachment ID.
  ///
  /// This is created locally for uniquely identifying a attachment.
  final String id;

  /// Shortcut for file size.
  ///
  /// {@macro fileSize}
  @JsonKey(includeToJson: false, includeFromJson: false)
  int? get fileSize => extraData['file_size'] as int?;

  /// Shortcut for file mimeType.
  ///
  /// {@macro mimeType}
  @JsonKey(includeToJson: false, includeFromJson: false)
  String? get mimeType => extraData['mime_type'] as String?;

  /// Known top level fields.
  /// Useful for [Serializer] methods.
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
    'original_width',
    'original_height',
  ];

  /// Known db specific top level fields.
  /// Useful for [Serializer] methods.
  static const dbSpecificTopLevelFields = [
    'id',
    'upload_state',
    'file',
  ];

  /// Serialize to json
  Map<String, dynamic> toJson() =>
      Serializer.moveFromExtraDataToRoot(_$AttachmentToJson(this))
        ..removeWhere((key, value) => dbSpecificTopLevelFields.contains(key));

  /// Serialize to db data
  Map<String, dynamic> toData() =>
      Serializer.moveFromExtraDataToRoot(_$AttachmentToJson(this));

  Attachment copyWith({
    String? id,
    String? type,
    String? titleLink,
    String? title,
    String? thumbUrl,
    String? text,
    String? pretext,
    String? ogScrapeUrl,
    String? imageUrl,
    String? footerIcon,
    String? footer,
    dynamic fields,
    String? fallback,
    String? color,
    String? authorName,
    String? authorLink,
    String? authorIcon,
    String? assetUrl,
    List<Action>? actions,
    int? originalWidth,
    int? originalHeight,
    AttachmentFile? file,
    UploadState? uploadState,
    Map<String, Object?>? extraData,
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
        originalWidth: originalWidth ?? this.originalWidth,
        originalHeight: originalHeight ?? this.originalHeight,
        file: file ?? this.file,
        uploadState: uploadState ?? this.uploadState,
        extraData: extraData ?? this.extraData,
      );

  Attachment merge(Attachment? other) {
    if (other == null) return this;
    return copyWith(
      type: other.type,
      titleLink: other.titleLink,
      title: other.title,
      thumbUrl: other.thumbUrl,
      text: other.text,
      pretext: other.pretext,
      ogScrapeUrl: other.ogScrapeUrl,
      imageUrl: other.imageUrl,
      footerIcon: other.footerIcon,
      footer: other.footer,
      fields: other.fields,
      fallback: other.fallback,
      color: other.color,
      authorName: other.authorName,
      authorLink: other.authorLink,
      authorIcon: other.authorIcon,
      assetUrl: other.assetUrl,
      actions: other.actions,
      originalWidth: other.originalWidth,
      originalHeight: other.originalHeight,
      file: other.file,
      uploadState: other.uploadState,
      extraData: other.extraData,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        titleLink,
        title,
        thumbUrl,
        text,
        pretext,
        ogScrapeUrl,
        imageUrl,
        footerIcon,
        footer,
        fields,
        fallback,
        color,
        authorName,
        authorLink,
        authorIcon,
        assetUrl,
        actions,
        originalWidth,
        originalHeight,
        file,
        uploadState,
        extraData,
      ];
}

/// {@template attachmentType}
/// A type of attachment that determines how the attachment is displayed and
/// handled by the system.
///
/// It can be one of the backend-specified types (image, file, giphy, video,
/// audio, voiceRecording) or application custom types like urlPreview.
/// {@endtemplate}
extension type const AttachmentType(String rawType) implements String {
  /// Backend specified types.
  static const AttachmentType image = AttachmentType('image');
  static const AttachmentType file = AttachmentType('file');
  static const AttachmentType giphy = AttachmentType('giphy');
  static const AttachmentType video = AttachmentType('video');
  static const AttachmentType audio = AttachmentType('audio');
  static const AttachmentType voiceRecording = AttachmentType('voiceRecording');

  /// Application custom types.
  static const AttachmentType urlPreview = AttachmentType('url_preview');

  /// Create a new instance from a json string.
  static AttachmentType? fromJson(String? rawType) {
    if (rawType == null) return null;
    return AttachmentType(rawType);
  }

  /// Serialize to json string.
  static String? toJson(String? type) => type;
}

extension AttachmentTypeHelper on Attachment {
  /// True if the attachment is an image.
  bool get isImage => type == AttachmentType.image;

  /// True if the attachment is a file.
  bool get isFile => type == AttachmentType.file;

  /// True if the attachment is a gif created using Giphy.
  bool get isGiphy => type == AttachmentType.giphy;

  /// True if the attachment is a video.
  bool get isVideo => type == AttachmentType.video;

  /// True if the attachment is an audio file.
  bool get isAudio => type == AttachmentType.audio;

  /// True if the attachment is a voice recording.
  bool get isVoiceRecording => type == AttachmentType.voiceRecording;

  /// True if the attachment is a URL preview.
  bool get isUrlPreview => type == AttachmentType.urlPreview;
}
