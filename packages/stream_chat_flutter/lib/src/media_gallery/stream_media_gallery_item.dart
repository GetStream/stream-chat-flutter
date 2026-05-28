import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A single tile inside a [StreamMediaGallery].
///
/// Renders [attachment]'s media filling a 1:1 square cell, clipped to a
/// `radius.xxs` corner, with optional overlays:
///
/// - An [author] avatar pinned to the top-leading corner, drawn with a
///   white outside-aligned border so it reads against any thumbnail.
/// - A "video" [StreamMediaBadge] pinned to the bottom-leading corner when
///   [attachment] is a video; the badge surfaces the video's duration in
///   `M:SS` format when present on `extraData['duration']`.
///
/// The tile is tappable when [onTap] / [onLongPress] is set; the ripple is
/// drawn over the media via a transparent [Material].
///
/// {@tool snippet}
///
/// Basic usage inside a [StreamMediaGallery]'s item builder:
///
/// ```dart
/// StreamMediaGalleryItem(
///   attachment: attachment,
///   author: message.user,
///   onTap: () => openPreview(index),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMediaGallery], the grid that lays out these tiles.
///  * [StreamMediaGalleryPreview], the full-screen viewer opened from a tap.
class StreamMediaGalleryItem extends StatelessWidget {
  /// Creates a [StreamMediaGalleryItem].
  const StreamMediaGalleryItem({
    super.key,
    required this.attachment,
    this.author,
    this.onTap,
    this.onLongPress,
  });

  /// The media attachment rendered by this tile.
  final Attachment attachment;

  /// Optional user to surface as a small avatar in the top-leading corner.
  ///
  /// When null, no avatar is drawn.
  final User? author;

  /// Called when the user taps this tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses this tile.
  final GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;

    final colorScheme = context.streamColorScheme;

    final isVideo = attachment.type == AttachmentType.video;

    Duration? videoDuration;
    if (isVideo) {
      final secs = attachment.extraData['duration'] as num?;
      if (secs != null) videoDuration = Duration(seconds: secs.round());
    }

    return Material(
      clipBehavior: .hardEdge,
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.all(radius.xxs),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Positioned.fill(
              child: StreamMediaAttachmentThumbnail(
                media: attachment,
                fit: BoxFit.cover,
              ),
            ),
            if (author case final author?)
              PositionedDirectional(
                top: spacing.xs,
                start: spacing.xs,
                child: StreamAvatarTheme(
                  data: StreamAvatarThemeData(
                    border: BoxBorder.all(
                      width: 2,
                      color: colorScheme.borderOnInverse,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  child: StreamUserAvatar(
                    user: author,
                    size: StreamAvatarSize.sm,
                    showOnlineIndicator: false,
                  ),
                ),
              ),
            if (isVideo)
              PositionedDirectional(
                start: spacing.xs,
                bottom: spacing.xs,
                child: StreamMediaBadge(
                  type: .video,
                  duration: videoDuration,
                  durationFormat: .exact,
                ),
              ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  onLongPress: onLongPress,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
