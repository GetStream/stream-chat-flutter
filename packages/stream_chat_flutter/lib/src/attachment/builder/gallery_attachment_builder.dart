part of 'attachment_widget_builder.dart';

const _kDefaultGalleryConstraints = BoxConstraints.tightFor(
  width: 256,
  height: 195,
);

/// {@template galleryAttachmentBuilder}
/// A widget builder for [AttachmentType.image], [AttachmentType.video] and
/// [AttachmentType.giphy] attachment types.
///
/// This builder will render a [StreamGalleryAttachment] widget when the message
/// has more than one image or video or giphy attachment.
/// {@endtemplate}
class GalleryAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro galleryAttachmentBuilder}
  const GalleryAttachmentBuilder({
    this.shape,
    this.padding = const EdgeInsets.all(2),
    this.spacing = 2,
    this.runSpacing = 2,
    this.constraints = _kDefaultGalleryConstraints,
    this.onAttachmentTap,
  });

  /// The shape of the gallery attachment.
  final ShapeBorder? shape;

  /// The constraints to apply to the gallery attachment widget.
  final BoxConstraints constraints;

  /// The padding to apply to the gallery attachment widget.
  final EdgeInsetsGeometry padding;

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

  /// The callback to call when the attachment is tapped.
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final images = attachments[AttachmentType.image];
    if (images != null && images.length > 1) return true;

    final videos = attachments[AttachmentType.video];
    if (videos != null && videos.length > 1) return true;

    final giphys = attachments[AttachmentType.giphy];
    if (giphys != null && giphys.length > 1) return true;

    if (images != null && videos != null) return true;
    if (images != null && giphys != null) return true;
    if (videos != null && giphys != null) return true;

    return false;
  }

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final galleryAttachments = [...attachments.values.expand((it) => it)];

    return Padding(
      padding: padding,
      child: StreamGalleryAttachment(
        shape: shape,
        message: message,
        spacing: spacing,
        runSpacing: runSpacing,
        constraints: constraints,
        attachments: galleryAttachments,
        itemBuilder: (context, index) {
          final attachment = galleryAttachments[index];

          VoidCallback? onTap;
          if (onAttachmentTap != null) {
            onTap = () => onAttachmentTap!(message, attachment);
          }

          return InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                StreamMediaAttachmentThumbnail(
                  media: attachment,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: StreamAttachmentUploadStateBuilder(
                    message: message,
                    attachment: attachment,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
