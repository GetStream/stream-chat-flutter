part of 'attachment_widget_builder.dart';

/// {@template imageAttachmentBuilder}
/// A widget builder for [AttachmentType.image] attachment type.
///
/// This builder is used when a message contains only a single image attachment.
/// {@endtemplate}
class ImageAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro imageAttachmentBuilder}
  const ImageAttachmentBuilder({
    this.style,
    this.constraints,
    this.onAttachmentTap,
  });

  /// The style of the image attachment container.
  ///
  /// When null, a default style with a rounded rectangle shape and border
  /// is used.
  final StreamMessageAttachmentStyle? style;

  /// The constraints to apply to the image attachment widget.
  final BoxConstraints? constraints;

  /// The callback to call when the attachment is tapped.
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final images = attachments[AttachmentType.image];
    return images != null && images.length == 1;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final image = attachments[AttachmentType.image]!.first;

    VoidCallback? onTap;
    if (onAttachmentTap != null) {
      onTap = () => onAttachmentTap!(message, image);
    }

    return StreamMessageAttachment(
      style: style,
      child: InkWell(
        onTap: onTap,
        child: StreamImageAttachment(
          message: message,
          constraints: constraints,
          image: image,
        ),
      ),
    );
  }
}
