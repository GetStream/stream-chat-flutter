import 'package:flutter/material.dart';
import '../../stream_chat_flutter.dart';
import 'stream_media_grid_delegate.dart';

/// A scrollable grid of [StreamMediaGalleryAttachment]s — the thumbnail
/// companion to [StreamMediaGalleryPreview].
///
/// Each cell is rendered by a [StreamMediaGalleryItem] in a 1:1 grid with
/// the sender's avatar surfaced on every tile. Inter-cell gutters default to
/// `spacing.xxxs` (2 logical pixels) so every gap in the grid is uniform. The
/// grid has no outer padding of its own; supply [StreamMediaGalleryProps.padding]
/// to inset it from its container.
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
    @Deprecated('Use gridDelegate instead.') int? crossAxisCount,
    SliverGridDelegate? gridDelegate,
    EdgeInsetsGeometry? padding,
    ScrollController? scrollController,
    ValueChanged<int>? onItemTap,
    ValueChanged<int>? onItemLongPress,
  }) : props = .new(
         attachments: attachments,
         crossAxisCount: crossAxisCount,
         gridDelegate: gridDelegate,
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
    @Deprecated('Use gridDelegate instead.') int? crossAxisCount,
    this.gridDelegate,
    this.padding,
    this.scrollController,
    this.onItemTap,
    this.onItemLongPress,
  }) : assert(
         crossAxisCount == null || gridDelegate == null,
         'Only one of crossAxisCount or gridDelegate can be provided. '
         'Prefer gridDelegate; crossAxisCount is deprecated.',
       ),
       _crossAxisCount = crossAxisCount;

  /// The attachments to display, in render order.
  final List<StreamMediaGalleryAttachment> attachments;

  /// The fixed number of tiles per row given to the constructor, or 3 when none
  /// was.
  ///
  /// Without a fixed number, the grid lays out its tiles with [gridDelegate] or,
  /// when that is null, picks the number of tiles per row from its width.
  @Deprecated('Use gridDelegate instead. The number of tiles per row now depends on the grid width.')
  int get crossAxisCount => _crossAxisCount ?? 3;
  final int? _crossAxisCount;

  /// The delegate that lays out the grid's tiles.
  ///
  /// When null, the grid shows square tiles, with more tiles per row as it gets
  /// wider.
  final SliverGridDelegate? gridDelegate;

  /// The padding around this grid.
  ///
  /// Defaults to null, leaving the grid to inherit any insets from its
  /// surroundings.
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
    return GridView.builder(
      padding: props.padding,
      controller: props.scrollController,
      itemCount: props.attachments.length,
      gridDelegate: _gridDelegate(context),
      itemBuilder: (context, index) {
        final ga = props.attachments[index];
        return StreamMediaGalleryItem(
          attachment: ga.attachment,
          author: ga.message.user,
          onTap: props.onItemTap == null ? null : () => props.onItemTap!(index),
          onLongPress: props.onItemLongPress == null ? null : () => props.onItemLongPress!(index),
        );
      },
    );
  }

  SliverGridDelegate _gridDelegate(BuildContext context) {
    if (props.gridDelegate case final gridDelegate?) return gridDelegate;

    final spacing = context.streamSpacing;

    if (props._crossAxisCount case final crossAxisCount?) {
      return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing.xxxs,
        mainAxisSpacing: spacing.xxxs,
      );
    }

    return StreamMediaGridDelegate(
      crossAxisSpacing: spacing.xxxs,
      mainAxisSpacing: spacing.xxxs,
    );
  }
}
