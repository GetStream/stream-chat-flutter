part of 'attachment_widget_builder.dart';

/// {@template urlAttachmentBuilder}
/// A widget builder for link preview attachment type.
///
/// This is used to show url attachments with a preview. e.g. youtube, twitter,
/// etc.
/// {@endtemplate}
class LinkPreviewAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro urlAttachmentBuilder}
  const LinkPreviewAttachmentBuilder({
    this.style,
    this.constraints,
    this.onAttachmentTap,
  });

  /// The style of the url attachment container.
  ///
  /// When null, a default style with a rounded rectangle shape, border,
  /// and background color is used.
  final StreamMessageAttachmentStyle? style;

  /// The constraints to apply to the url attachment widget.
  final BoxConstraints? constraints;

  /// The callback to call when the attachment is tapped.
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  @override
  bool canHandle(
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    final urls = attachments[AttachmentType.urlPreview];
    return urls != null && urls.isNotEmpty;
  }

  @override
  Widget? build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final spacing = context.streamSpacing;

    final urlPreviews = attachments[AttachmentType.urlPreview]!;

    Widget _buildUrlPreview(Attachment urlPreview) {
      VoidCallback? onTap;
      if (onAttachmentTap != null) {
        onTap = () => onAttachmentTap!(message, urlPreview);
      }

      return StreamMessageAttachment(
        style: style,
        child: InkWell(
          onTap: onTap,
          child: StreamLinkPreviewAttachment(
            message: message,
            urlAttachment: urlPreview,
            constraints: constraints,
          ),
        ),
      );
    }

    if (urlPreviews.length == 1) {
      return _buildUrlPreview(urlPreviews.first);
    }

    return Column(
      spacing: spacing.xs,
      children: <Widget>[
        for (final urlPreview in urlPreviews) _buildUrlPreview(urlPreview),
      ],
    );
  }
}
