import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Bottom chrome bar for a [StreamMediaGalleryPreview].
///
/// Wraps [StreamBottomAppBar] with gallery-specific defaults:
///
/// - The leading slot is fixed to a share icon button that invokes
///   [onSharePressed].
/// - The [title] slot accepts any [Widget] but typically renders the
///   localised page counter (e.g. "1 of 9").
/// - The trailing slot is fixed to a gallery-grid icon button that invokes
///   [onGalleryPressed].
///
/// {@tool snippet}
///
/// Build the footer from the active page index inside a preview builder:
///
/// ```dart
/// StreamMediaGalleryPreviewFooter(
///   title: Text(
///     context.translations.galleryPaginationText(
///       currentPage: currentPage,
///       totalPages: totalPages,
///     ),
///   ),
///   onSharePressed: shareCurrentAttachment,
///   onGalleryPressed: openThumbnailSheet,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMediaGalleryPreview], which renders this footer in its chrome.
///  * [StreamMediaGalleryPreviewHeader], the matching top chrome.
///  * [StreamBottomAppBar], the underlying bottom app bar this widget wraps.
class StreamMediaGalleryPreviewFooter extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [StreamMediaGalleryPreviewFooter].
  const StreamMediaGalleryPreviewFooter({
    super.key,
    this.title,
    this.onSharePressed,
    this.onGalleryPressed,
  });

  /// {@macro StreamBottomAppBar.title}
  final Widget? title;

  /// Called when the share button is pressed.
  ///
  /// When null, the button is rendered disabled.
  final VoidCallback? onSharePressed;

  /// Called when the gallery-grid button is pressed.
  ///
  /// When null, the button is rendered disabled.
  final VoidCallback? onGalleryPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kStreamToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;

    return StreamBottomAppBar(
      leading: StreamButton.icon(
        type: StreamButtonType.ghost,
        style: StreamButtonStyle.secondary,
        icon: Icon(icons.export),
        onPressed: onSharePressed,
      ),
      title: title,
      trailing: StreamButton.icon(
        type: StreamButtonType.ghost,
        style: StreamButtonStyle.secondary,
        icon: Icon(icons.gallery),
        onPressed: onGalleryPressed,
      ),
    );
  }
}
