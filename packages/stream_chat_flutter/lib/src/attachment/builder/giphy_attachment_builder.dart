part of 'attachment_widget_builder.dart';

const _kDefaultGiphyConstraints = BoxConstraints(
  minWidth: 170,
  maxWidth: 256,
  minHeight: 100,
  maxHeight: 300,
);

/// {@template giphyAttachmentBuilder}
/// A widget builder for [AttachmentType.giphy] attachment type.
///
/// This builder is used when a message contains only a single giphy attachment.
/// {@endtemplate}
class GiphyAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro giphyAttachmentBuilder}
  const GiphyAttachmentBuilder({
    this.shape,
    this.padding = const EdgeInsets.all(2),
    this.constraints = _kDefaultGiphyConstraints,
    this.onAttachmentTap,
  });

  /// The shape of the giphy attachment.
  final ShapeBorder? shape;

  /// The constraints to apply to the giphy attachment widget.
  final BoxConstraints constraints;

  /// The padding to apply to the giphy attachment widget.
  final EdgeInsetsGeometry padding;

  /// The callback to call when the attachment is tapped.
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final giphyAttachments = attachments[AttachmentType.giphy];
    return giphyAttachments != null && giphyAttachments.length == 1;
  }

  @override
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final giphy = attachments[AttachmentType.giphy]!.first;

    VoidCallback? onTap;
    if (onAttachmentTap != null) {
      onTap = () => onAttachmentTap!(message, giphy);
    }

    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onTap,
        child: StreamGiphyAttachment(
          message: message,
          constraints: constraints,
          giphy: giphy,
          shape: shape,
        ),
      ),
    );
  }
}
