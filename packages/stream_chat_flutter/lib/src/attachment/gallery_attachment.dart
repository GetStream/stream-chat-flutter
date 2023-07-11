import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/giphy_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/image_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/video_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/misc/flex_grid.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamGalleryAttachment}
/// Constructs a gallery of images, videos, and gifs from a list of attachments.
///
/// This widget uses a [FlexGrid] to display the attachments in a grid format.
/// The grid will automatically resize based on the size of the attachment.
/// {@endtemplate}
///
/// See also:
///
///  * [StreamImageAttachmentThumbnail], which is used to display the image
///  thumbnails.
///  * [StreamVideoAttachmentThumbnail], which is used to display the video
///  thumbnails.
///  * [StreamGiphyAttachmentThumbnail], which is used to display the gif
///  thumbnails.
class StreamGalleryAttachment extends StatelessWidget {
  /// {@macro streamGalleryAttachment}
  const StreamGalleryAttachment({
    super.key,
    required this.attachments,
    required this.message,
    this.shape,
    this.constraints = const BoxConstraints(),
    this.spacing = 2.0,
    this.runSpacing = 2.0,
    required this.itemBuilder,
  });

  /// List of attachments to show
  final List<Attachment> attachments;

  /// The [Message] that the images are attached to
  final Message message;

  /// The shape of the attachment.
  ///
  /// Defaults to [RoundedRectangleBorder] with a radius of 14.
  final ShapeBorder? shape;

  /// The constraints of the [attachments]
  final BoxConstraints constraints;

  /// How much space to place between children in a run in the main axis.
  ///
  /// For example, if [spacing] is 10.0, the children will be spaced at least
  /// 10.0 logical pixels apart in the main axis.
  ///
  /// Defaults to 2.0.
  final double spacing;

  /// How much space to place between the runs themselves in the cross axis.
  ///
  /// For example, if [runSpacing] is 10.0, the runs will be spaced at least
  /// 10.0 logical pixels apart in the cross axis.
  ///
  /// Defaults to 2.0.
  final double runSpacing;

  /// Item builder for the gallery.
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    assert(
      attachments.length >= 2,
      'Gallery should have at least 2 attachments, found ${attachments.length}',
    );

    final chatTheme = StreamChatTheme.of(context);
    final colorTheme = chatTheme.colorTheme;
    final shape = this.shape ??
        RoundedRectangleBorder(
          side: BorderSide(
            color: colorTheme.borders,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(14),
        );

    return Container(
      constraints: constraints,
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(shape: shape),
      // Added a builder just for the sake of calculating the image count
      // and building the appropriate layout based on the image count.
      child: Builder(
        builder: (context) {
          final attachmentCount = attachments.length;
          if (attachmentCount == 2) {
            return _buildForTwo(context, attachments);
          }

          if (attachmentCount == 3) {
            return _buildForThree(context, attachments);
          }

          return _buildForFourOrMore(context, attachments);
        },
      ),
    );
  }

  Widget _buildForTwo(BuildContext context, List<Attachment> attachments) {
    final aspectRatio1 = attachments[0].originalSize?.aspectRatio;
    final aspectRatio2 = attachments[1].originalSize?.aspectRatio;

    // check if one image is landscape and other is portrait or vice versa
    final isLandscape1 = aspectRatio1 != null && aspectRatio1 > 1;
    final isLandscape2 = aspectRatio2 != null && aspectRatio2 > 1;

    // Both the images are landscape.
    if (isLandscape1 && isLandscape2) {
      // ----------
      // |        |
      // ----------
      // |        |
      // ----------
      return FlexGrid(
        pattern: const [
          [1],
          [1],
        ],
        children: [
          itemBuilder(context, 0),
          itemBuilder(context, 1),
        ],
      );
    }

    // Both the images are portrait.
    if (!isLandscape1 && !isLandscape2) {
      // -----------
      // |    |    |
      // |    |    |
      // |    |    |
      // -----------
      return FlexGrid(
        pattern: const [
          [1, 1],
        ],
        children: [
          itemBuilder(context, 0),
          itemBuilder(context, 1),
        ],
      );
    }

    // Layout on the basis of isLandscape1.
    // 1. True
    // -----------
    // |      |  |
    // |      |  |
    // |      |  |
    // -----------
    //
    // 2. False
    // -----------
    // |  |      |
    // |  |      |
    // |  |      |
    // -----------
    return FlexGrid(
      pattern: [
        if (isLandscape1) [2, 1] else [1, 2],
      ],
      children: [
        itemBuilder(context, 0),
        itemBuilder(context, 1),
      ],
    );
  }

  Widget _buildForThree(BuildContext context, List<Attachment> attachments) {
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
      reverse: !isLandscape1,
      children: [
        itemBuilder(context, 0),
        itemBuilder(context, 1),
        itemBuilder(context, 2),
      ],
    );
  }

  Widget _buildForFourOrMore(
      BuildContext context, List<Attachment> attachments) {
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
      children: children,
      overlayBuilder: (context, remaining) {
        return IgnorePointer(
          child: ColoredBox(
            color: Colors.black38,
            child: Center(
              child: Text(
                '+$remaining',
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
