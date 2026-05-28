import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/flex_grid.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A responsive grid layout for multiple media attachments.
///
/// [StreamGalleryAttachment] arranges two or more image, video, or GIF
/// attachments in a responsive grid layout.
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamGalleryAttachment(
///   message: message,
///   attachments: mediaAttachments,
///   itemBuilder: (context, index) => MyMediaThumbnail(
///     attachment: mediaAttachments[index],
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamGalleryAttachmentProps], which configures this widget.
///  * [DefaultStreamGalleryAttachment], the default implementation.
class StreamGalleryAttachment extends StatelessWidget {
  /// Creates a [StreamGalleryAttachment].
  StreamGalleryAttachment({
    super.key,
    required Message message,
    required List<Attachment> attachments,
    BoxConstraints? constraints,
    double? spacing,
    double? runSpacing,
    required IndexedWidgetBuilder itemBuilder,
  }) : props = .new(
         message: message,
         attachments: attachments,
         constraints: constraints,
         spacing: spacing,
         runSpacing: runSpacing,
         itemBuilder: itemBuilder,
       );

  /// The properties that configure this attachment.
  final StreamGalleryAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamGalleryAttachmentProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamGalleryAttachment(props: props);
  }
}

/// Properties for configuring a [StreamGalleryAttachment].
///
/// This class holds all the configuration options for a gallery attachment,
/// allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamGalleryAttachment], which uses these properties.
///  * [DefaultStreamGalleryAttachment], the default implementation.
class StreamGalleryAttachmentProps {
  /// Creates properties for a gallery attachment.
  const StreamGalleryAttachmentProps({
    required this.message,
    required this.attachments,
    this.constraints,
    this.spacing,
    this.runSpacing,
    required this.itemBuilder,
  });

  /// The [Message] that the images are attached to.
  final Message message;

  /// The list of media attachments to display in the grid.
  final List<Attachment> attachments;

  /// The constraints to use when displaying the gallery.
  final BoxConstraints? constraints;

  /// How much space to place between children in a run in the main axis.
  ///
  /// For example, if [spacing] is 10.0, the children will be spaced at least
  /// 10.0 logical pixels apart in the main axis.
  ///
  /// When null, defaults to [StreamSpacing.xxs].
  final double? spacing;

  /// How much space to place between the runs themselves in the cross axis.
  ///
  /// For example, if [runSpacing] is 10.0, the runs will be spaced at least
  /// 10.0 logical pixels apart in the cross axis.
  ///
  /// When null, defaults to [StreamSpacing.xxs].
  final double? runSpacing;

  /// Item builder for the gallery.
  final IndexedWidgetBuilder itemBuilder;
}

const _kDefaultConstraints = BoxConstraints.tightFor(width: 256, height: 195);

/// The default implementation of [StreamGalleryAttachment].
///
/// Renders a responsive grid of media attachment thumbnails.
///
/// See also:
///
///  * [StreamGalleryAttachment], the public API widget.
///  * [StreamGalleryAttachmentProps], which configures this widget.
class DefaultStreamGalleryAttachment extends StatelessWidget {
  /// Creates a default Stream gallery attachment.
  const DefaultStreamGalleryAttachment({
    super.key,
    required this.props,
  });

  /// The properties that configure this attachment.
  final StreamGalleryAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final attachments = props.attachments;
    assert(
      attachments.length >= 2,
      'Gallery should have at least 2 attachments, found ${attachments.length}',
    );

    final streamSpacing = context.streamSpacing;
    final constraints = props.constraints ?? _kDefaultConstraints;

    final spacing = props.spacing ?? streamSpacing.xxs;
    final runSpacing = props.runSpacing ?? streamSpacing.xxs;

    return ConstrainedBox(
      constraints: constraints,
      child: Builder(
        builder: (context) => switch (attachments.length) {
          2 => _buildForTwo(context, attachments, props.itemBuilder, spacing: spacing, runSpacing: runSpacing),
          3 => _buildForThree(context, attachments, props.itemBuilder, spacing: spacing, runSpacing: runSpacing),
          _ => _buildForFourOrMore(context, attachments, props.itemBuilder, spacing: spacing, runSpacing: runSpacing),
        },
      ),
    );
  }

  Widget _buildForTwo(
    BuildContext context,
    List<Attachment> attachments,
    IndexedWidgetBuilder itemBuilder, {
    required double spacing,
    required double runSpacing,
  }) {
    final aspectRatio1 = attachments[0].originalSize?.aspectRatio;
    final aspectRatio2 = attachments[1].originalSize?.aspectRatio;

    // Check if one image is landscape and other is portrait or vice versa.
    final isLandscape1 = aspectRatio1 != null && aspectRatio1 > 1;
    final isLandscape2 = aspectRatio2 != null && aspectRatio2 > 1;

    // Both the images are landscape.
    // ----------
    // |        |
    // ----------
    // |        |
    // ----------
    if (isLandscape1 && isLandscape2) {
      return FlexGrid(
        pattern: const [
          [1],
          [1],
        ],
        spacing: spacing,
        runSpacing: runSpacing,
        children: [
          itemBuilder(context, 0),
          itemBuilder(context, 1),
        ],
      );
    }

    // Portrait, mixed, or unknown — strict 50/50 width split with cover crop.
    // -----------
    // |    |    |
    // |    |    |
    // |    |    |
    // -----------
    return FlexGrid(
      pattern: const [
        [1, 1],
      ],
      spacing: spacing,
      runSpacing: runSpacing,
      children: [
        itemBuilder(context, 0),
        itemBuilder(context, 1),
      ],
    );
  }

  Widget _buildForThree(
    BuildContext context,
    List<Attachment> attachments,
    IndexedWidgetBuilder itemBuilder, {
    required double spacing,
    required double runSpacing,
  }) {
    final aspectRatio1 = attachments[0].originalSize?.aspectRatio;
    final isLandscape1 = aspectRatio1 != null && aspectRatio1 > 1;

    // We layout on the basis of isLandscape1.
    // 1. True
    // -----------
    // |         |
    // |         |
    // |---------|
    // |    |    |
    // |    |    |
    // -----------
    //
    // 2. False
    // -----------
    // |    |    |
    // |    |    |
    // |    |----|
    // |    |    |
    // |    |    |
    // -----------
    return FlexGrid(
      pattern: const [
        [1],
        [1, 1],
      ],
      spacing: spacing,
      runSpacing: runSpacing,
      reverse: !isLandscape1,
      children: [
        itemBuilder(context, 0),
        itemBuilder(context, 1),
        itemBuilder(context, 2),
      ],
    );
  }

  Widget _buildForFourOrMore(
    BuildContext context,
    List<Attachment> attachments,
    IndexedWidgetBuilder itemBuilder, {
    required double spacing,
    required double runSpacing,
  }) {
    final pattern = <List<int>>[];
    final children = <Widget>[];

    for (var i = 0; i < attachments.length; i++) {
      if (i.isEven) {
        pattern.add([1]);
      } else {
        pattern.last.add(1);
      }

      children.add(itemBuilder(context, i));
    }

    final radius = context.streamRadius;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    // -----------
    // |    |    |
    // |    |    |
    // ------------
    // |    |    |
    // |    |    |
    // ------------
    return FlexGrid(
      pattern: pattern,
      maxChildren: 4,
      spacing: spacing,
      runSpacing: runSpacing,
      children: children,
      overlayBuilder: (context, remaining) {
        return IgnorePointer(
          child: Material(
            clipBehavior: .hardEdge,
            color: colorScheme.backgroundOverlayDark,
            shape: RoundedSuperellipseBorder(borderRadius: .all(radius.md)),
            child: Center(
              child: Text(
                '+$remaining',
                style: textTheme.headingLg.copyWith(
                  color: colorScheme.textOnAccent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
