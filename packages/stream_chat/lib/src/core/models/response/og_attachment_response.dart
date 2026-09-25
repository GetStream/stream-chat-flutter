import 'package:freezed_annotation/freezed_annotation.dart';

part 'og_attachment_response.freezed.dart';

/// The OpenGraph metadata scraped for a URL, returned by [StreamChatClient.enrichUrl].
///
/// [Attachment.fromOGAttachment] builds a link preview attachment from it.
@freezed
class OGAttachmentResponse with _$OGAttachmentResponse {
  /// Creates a new [OGAttachmentResponse].
  const OGAttachmentResponse({
    required this.duration,
    this.ogScrapeUrl,
    this.assetUrl,
    this.authorLink,
    this.authorName,
    this.imageUrl,
    this.text,
    this.thumbUrl,
    this.title,
    this.titleLink,
    this.type,
  });

  /// How long the server took to handle the request, such as `4.21ms`.
  @override
  final String duration;

  /// The URL of the page that was scraped.
  ///
  /// `null` when the response leaves it out; the API does not guarantee it.
  @override
  final String? ogScrapeUrl;

  /// The URL of the audio, video or image the page links to.
  @override
  final String? assetUrl;

  /// The URL of the page's author.
  @override
  final String? authorLink;

  /// The name of the page's author, such as the site it was published on.
  @override
  final String? authorName;

  /// The URL of the image the page is previewed with.
  @override
  final String? imageUrl;

  /// The description of the page.
  @override
  final String? text;

  /// The URL of a thumbnail of the page's image.
  @override
  final String? thumbUrl;

  /// The title of the page.
  @override
  final String? title;

  /// The URL the title links to.
  @override
  final String? titleLink;

  /// The kind of media the page carries, such as `image`, `video` or `audio`.
  @override
  final String? type;
}
