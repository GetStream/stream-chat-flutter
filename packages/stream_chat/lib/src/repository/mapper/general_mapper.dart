import '../../../open_api/api.dart' as api;
import '../../core/models/response/og_attachment_response.dart';

/// Maps a generated [api.GetOGResponse] to an [OGAttachmentResponse].
extension GetOGResponseMapper on api.GetOGResponse {
  /// Converts this response into an [OGAttachmentResponse].
  ///
  /// The `requestedUrl` stands in for `og_scrape_url` if the response leaves it out.
  OGAttachmentResponse toModel({required String requestedUrl}) => OGAttachmentResponse(
    duration: duration,
    ogScrapeUrl: ogScrapeUrl ?? requestedUrl,
    assetUrl: assetUrl,
    authorLink: authorLink,
    authorName: authorName,
    imageUrl: imageUrl,
    text: text,
    thumbUrl: thumbUrl,
    title: title,
    titleLink: titleLink,
    type: type,
  );
}
