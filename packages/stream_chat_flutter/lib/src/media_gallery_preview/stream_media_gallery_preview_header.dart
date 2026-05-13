import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Top chrome bar for a [StreamMediaGalleryPreview].
///
/// Wraps [StreamAppBar] with gallery-specific defaults — the optional
/// [title] / [subtitle] slots accept any [Widget] but typically render the
/// sender's name and the localised sent timestamp.
///
/// A back affordance is auto-implied on the leading slot from the
/// enclosing route — see [StreamAppBar] for the platform-aware resolution.
///
/// {@tool snippet}
///
/// Build the header from the active package inside a preview builder:
///
/// ```dart
/// StreamMediaGalleryPreviewHeader(
///   title: Text(message.user?.name ?? ''),
///   subtitle: Text(
///     context.translations.sentAtText(
///       date: message.createdAt,
///       time: message.createdAt,
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMediaGalleryPreview], which renders this header in its chrome.
///  * [StreamMediaGalleryPreviewFooter], the matching bottom chrome.
///  * [StreamAppBar], the underlying app bar this widget wraps.
class StreamMediaGalleryPreviewHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [StreamMediaGalleryPreviewHeader].
  const StreamMediaGalleryPreviewHeader({
    super.key,
    this.title,
    this.subtitle,
  });

  /// {@macro StreamAppBar.title}
  final Widget? title;

  /// {@macro StreamAppBar.subtitle}
  final Widget? subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(kStreamToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return StreamAppBar(
      title: title,
      subtitle: subtitle,
    );
  }
}
