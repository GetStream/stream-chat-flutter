import '../../../open_api/api.dart' as api;
import '../../core/models/response/og_attachment_response.dart';

/// Maps a generated [api.GetOGResponse] to an [OGAttachmentResponse].
extension GetOGResponseMapper on api.GetOGResponse {
  /// Converts this response into an [OGAttachmentResponse].
  ///
  /// Keeps the ten fields a link preview is built from, plus [duration].
  OGAttachmentResponse toModel() => OGAttachmentResponse(
    duration: duration,
    ogScrapeUrl: ogScrapeUrl,
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
