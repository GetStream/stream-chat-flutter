import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// A media attachment paired with its parent [Message] for use in a media
/// gallery.
///
/// [StreamMediaGalleryAttachment] is the input format consumed by
/// [StreamMediaGallery] (the thumbnail grid) and [StreamMediaGalleryPreview]
/// (the full-screen swipeable viewer). The bundled [message] lets each
/// surface render the sender / timestamp metadata alongside the media
/// without a separate lookup.
///
/// {@tool snippet}
///
/// Build a list from a message's media attachments:
///
/// ```dart
/// final attachments = [
///   for (final a in message.attachments.where((it) =>
///       it.type == AttachmentType.image ||
///       it.type == AttachmentType.video ||
///       it.type == AttachmentType.giphy))
///     StreamMediaGalleryAttachment(attachment: a, message: message),
/// ];
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMediaGallery], the thumbnail grid that consumes these.
///  * [StreamMediaGalleryPreview], the full-screen swipeable viewer.
class StreamMediaGalleryAttachment {
  /// Creates a [StreamMediaGalleryAttachment].
  const StreamMediaGalleryAttachment({
    required this.attachment,
    required this.message,
  });

  /// The media attachment being shown.
  final Attachment attachment;

  /// The [Message] [attachment] was sent on.
  ///
  /// Used by gallery surfaces to surface sender / timestamp metadata.
  final Message message;
}

/// Convenience helpers for producing [StreamMediaGalleryAttachment]s from a
/// [Message].
extension MessageMediaGalleryX on Message {
  /// Returns one [StreamMediaGalleryAttachment] per [Message.attachments]
  /// entry on this message, each paired with the message itself.
  ///
  /// Pass [filter] to narrow the result — typically to keep only media
  /// attachment types (image / video / giphy).
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// final mediaOnly = message.toMediaGalleryAttachments(
  ///   filter: (a) =>
  ///       a.type == AttachmentType.image ||
  ///       a.type == AttachmentType.video ||
  ///       a.type == AttachmentType.giphy,
  /// );
  /// ```
  /// {@end-tool}
  List<StreamMediaGalleryAttachment> toMediaGalleryAttachments({bool Function(Attachment)? filter}) {
    final source = filter == null ? attachments : attachments.where(filter);
    return [for (final a in source) StreamMediaGalleryAttachment(attachment: a, message: this)];
  }
}
