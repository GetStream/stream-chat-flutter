import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// One page in a [StreamMediaGalleryPreview].
///
/// Renders [attachment] based on its type:
///
/// - image / giphy → [PhotoView] over a [StreamMediaAttachmentThumbnail]
///   for pinch-to-zoom and pan.
/// - video → [StreamVideoPlayer] — picks the right backend per platform
///   and pauses itself when this page is no longer active.
/// - anything else → an empty widget.
///
/// {@tool snippet}
///
/// Use inside a custom preview page builder:
///
/// ```dart
/// PageView.builder(
///   itemCount: attachments.length,
///   itemBuilder: (_, i) => StreamMediaGalleryPreviewItem(
///     attachment: attachments[i].attachment,
///     pageIndex: i,
///     autoplay: true,
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMediaGalleryPreview], the host viewer.
///  * [StreamVideoPlayer], the video backend used for video attachments.
///  * [StreamMediaAttachmentThumbnail], the image / video poster widget.
class StreamMediaGalleryPreviewItem extends StatelessWidget {
  /// Creates a [StreamMediaGalleryPreviewItem].
  const StreamMediaGalleryPreviewItem({
    super.key,
    required this.attachment,
    this.pageIndex = 0,
    this.autoplay = false,
  });

  /// The attachment to render.
  final Attachment attachment;

  /// The 0-based index of this page in the enclosing preview. Forwarded to
  /// [StreamVideoPlayer] so it can decide whether to play or pause based on
  /// the active page from [StreamMediaGalleryPreviewScope].
  final int pageIndex;

  /// Whether to start video playback automatically when this page becomes
  /// active. No effect for non-video attachments.
  final bool autoplay;

  @override
  Widget build(BuildContext context) {
    final type = attachment.type;

    if (type == .image || type == .giphy) {
      return PhotoView.customChild(
        maxScale: PhotoViewComputedScale.covered,
        minScale: PhotoViewComputedScale.contained,
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
        child: StreamMediaAttachmentThumbnail(media: attachment),
      );
    }

    if (type == .video) {
      return StreamVideoPlayer(
        autoplay: autoplay,
        pageIndex: pageIndex,
        attachment: attachment,
      );
    }

    return const Empty();
  }
}
