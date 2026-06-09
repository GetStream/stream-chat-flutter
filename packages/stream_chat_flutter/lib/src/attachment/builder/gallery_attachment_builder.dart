part of 'attachment_widget_builder.dart';

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
    this.style,
    this.spacing,
    this.runSpacing,
    this.constraints,
    this.onAttachmentTap,
  });

  /// The style of the gallery attachment container.
  ///
  /// When null, a default style with a rounded rectangle shape and border
  /// is used.
  final StreamMessageAttachmentStyle? style;

  /// The constraints to apply to the gallery attachment widget.
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
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final effectiveStyle = StreamMessageAttachmentStyle.from(
      backgroundColor: StreamColors.transparent,
    ).merge(style);

    final galleryAttachments = [...attachments.values.expand((it) => it)];

    return StreamMessageAttachment(
      style: effectiveStyle,
      child: StreamGalleryAttachment(
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

          return StreamMessageAttachment(
            style: .from(padding: .zero),
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: .expand,
                alignment: .center,
                children: [
                  StreamMediaAttachmentThumbnail(
                    media: attachment,
                    fit: BoxFit.cover,
                  ),
                  if (attachment.type == .video && attachment.uploadState.isSuccess) ...[
                    const Center(child: StreamVideoPlayIndicator(size: .lg)),
                  ] else ...[
                    Positioned.fill(
                      child: StreamAttachmentUploadStateBuilder(
                        message: message,
                        attachment: attachment,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
