import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A scrollable grid of [StreamMediaGalleryAttachment]s — the thumbnail
/// companion to [StreamMediaGalleryPreview].
///
/// Each cell is rendered by a [StreamMediaGalleryItem] in a 1:1 grid with
/// the sender's avatar surfaced on every tile. Inter-cell gutters and the
/// outer padding both default to `spacing.xxxs` (2 logical pixels) so
/// every gap in the grid is uniform; pass [StreamMediaGalleryProps.padding]
/// to override.
///
/// {@tool snippet}
///
/// Open the full-screen viewer when a tile is tapped:
///
/// ```dart
/// StreamMediaGallery(
///   attachments: attachments,
///   onItemTap: (index) => Navigator.push(
///     context,
///     MaterialPageRoute(
///       builder: (_) => StreamMediaGalleryPreview(
///         attachments: attachments,
///         initialIndex: index,
///       ),
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMediaGalleryItem], the cell widget.
///  * [StreamMediaGalleryPreview], the full-screen swipeable viewer.
///  * [DefaultStreamMediaGallery], the default implementation.
class StreamMediaGallery extends StatelessWidget {
  /// Creates a [StreamMediaGallery].
  StreamMediaGallery({
    super.key,
    required List<StreamMediaGalleryAttachment> attachments,
    int crossAxisCount = 3,
    EdgeInsetsGeometry? padding,
    ScrollController? scrollController,
    ValueChanged<int>? onItemTap,
    ValueChanged<int>? onItemLongPress,
  }) : props = .new(
         attachments: attachments,
         crossAxisCount: crossAxisCount,
         padding: padding,
         scrollController: scrollController,
         onItemTap: onItemTap,
         onItemLongPress: onItemLongPress,
       );

  /// The properties that configure this gallery.
  final StreamMediaGalleryProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamMediaGalleryProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamMediaGallery(props: props);
  }
}

/// Properties for configuring a [StreamMediaGallery].
///
/// This class holds all configuration options for the gallery, allowing
/// them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamMediaGallery], which uses these properties.
///  * [DefaultStreamMediaGallery], the default implementation.
@immutable
class StreamMediaGalleryProps {
  /// Creates properties for a media gallery.
  const StreamMediaGalleryProps({
    required this.attachments,
    this.crossAxisCount = 3,
    this.padding,
    this.scrollController,
    this.onItemTap,
    this.onItemLongPress,
  });

  /// The attachments to display, in render order.
  final List<StreamMediaGalleryAttachment> attachments;

  /// Number of tiles per row. Defaults to 3.
  final int crossAxisCount;

  /// Padding around the grid.
  final EdgeInsetsGeometry? padding;

  /// Scroll controller for the underlying [GridView].
  final ScrollController? scrollController;

  /// Called when the user taps the tile at the given index.
  final ValueChanged<int>? onItemTap;

  /// Called when the user long-presses the tile at the given index.
  final ValueChanged<int>? onItemLongPress;
}

/// The default implementation of [StreamMediaGallery].
///
/// See also:
///
///  * [StreamMediaGallery], the public API widget.
///  * [StreamMediaGalleryProps], which configures this widget.
class DefaultStreamMediaGallery extends StatelessWidget {
  /// Creates a default media gallery with the given [props].
  const DefaultStreamMediaGallery({super.key, required this.props});

  /// The properties that configure this gallery.
  final StreamMediaGalleryProps props;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final effectivePadding = props.padding ?? EdgeInsets.all(spacing.xxxs);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: GridView.builder(
        padding: effectivePadding,
        controller: props.scrollController,
        itemCount: props.attachments.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: props.crossAxisCount,
          crossAxisSpacing: spacing.xxxs,
          mainAxisSpacing: spacing.xxxs,
        ),
        itemBuilder: (context, index) {
          final ga = props.attachments[index];
          return StreamMediaGalleryItem(
            attachment: ga.attachment,
            author: ga.message.user,
            onTap: props.onItemTap == null ? null : () => props.onItemTap!(index),
            onLongPress: props.onItemLongPress == null ? null : () => props.onItemLongPress!(index),
          );
        },
      ),
    );
  }
}
