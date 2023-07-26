part of 'attachment_widget_builder.dart';

const _kDefaultImageConstraints = BoxConstraints(
  minWidth: 170,
  maxWidth: 256,
  minHeight: 100,
  maxHeight: 300,
);

/// {@template imageAttachmentBuilder}
/// A widget builder for [AttachmentType.image] attachment type.
///
/// This builder is used when a message contains only a single image attachment.
/// {@endtemplate}
class ImageAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro imageAttachmentBuilder}
  const ImageAttachmentBuilder({
    this.shape,
    this.padding = const EdgeInsets.all(2),
    this.constraints = _kDefaultImageConstraints,
    this.onAttachmentTap,
  });

  /// The shape of the image attachment.
  final ShapeBorder? shape;

  /// The constraints to apply to the image attachment widget.
  final BoxConstraints constraints;

  /// The padding to apply to the image attachment widget.
  final EdgeInsetsGeometry padding;

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
  Widget build(
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

    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onTap,
        child: StreamImageAttachment(
          shape: shape,
          message: message,
          constraints: constraints,
          image: image,
        ),
      ),
    );
  }
}
