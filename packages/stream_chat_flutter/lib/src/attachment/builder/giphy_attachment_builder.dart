part of 'attachment_widget_builder.dart';

/// {@template giphyAttachmentBuilder}
/// A widget builder for [AttachmentType.giphy] attachment type.
///
/// This builder is used when a message contains only a single giphy attachment.
/// {@endtemplate}
class GiphyAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro giphyAttachmentBuilder}
  const GiphyAttachmentBuilder({
    this.style,
    this.constraints,
    this.onAttachmentTap,
  });

  /// The style of the giphy attachment container.
  ///
  /// When null, a default style with a rounded rectangle shape and border
  /// is used.
  final StreamMessageAttachmentStyle? style;

  /// The constraints to apply to the giphy attachment widget.
  final BoxConstraints? constraints;

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
  Widget? build(
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

    return StreamMessageAttachment(
      style: style,
      child: InkWell(
        onTap: onTap,
        child: StreamGiphyAttachment(
          message: message,
          constraints: constraints,
          giphy: giphy,
        ),
      ),
    );
  }
}
