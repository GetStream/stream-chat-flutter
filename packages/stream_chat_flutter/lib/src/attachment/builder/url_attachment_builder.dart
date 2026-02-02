part of 'attachment_widget_builder.dart';

const _kDefaultUrlAttachmentConstraints = BoxConstraints(maxWidth: 256);

/// {@template urlAttachmentBuilder}
/// A widget builder for url attachment type.
///
/// This is used to show url attachments with a preview. e.g. youtube, twitter,
/// etc.
/// {@endtemplate}
class UrlAttachmentBuilder extends StreamAttachmentWidgetBuilder {
  /// {@macro urlAttachmentBuilder}
  const UrlAttachmentBuilder({
    this.shape,
    this.padding = const EdgeInsets.all(8),
    this.constraints = _kDefaultUrlAttachmentConstraints,
    this.onAttachmentTap,
  });

  /// The shape of the url attachment.
  final ShapeBorder? shape;

  /// The constraints to apply to the url attachment widget.
  final BoxConstraints constraints;

  /// The padding to apply to the url attachment widget.
  final EdgeInsetsGeometry padding;

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
  Widget build(
    BuildContext context,
    Message message,
    Map<String, List<Attachment>> attachments,
  ) {
    assert(debugAssertCanHandle(message, attachments), '');

    final urlPreviews = attachments[AttachmentType.urlPreview]!;

    final client = StreamChat.of(context).client;
    final isMyMessage = message.user?.id == client.state.currentUser?.id;

    final streamChatTheme = StreamChatTheme.of(context);
    final messageTheme = isMyMessage
        ? streamChatTheme.ownMessageTheme
        : streamChatTheme.otherMessageTheme;

    Widget _buildUrlPreview(Attachment urlPreview) {
      VoidCallback? onTap;
      if (onAttachmentTap != null) {
        onTap = () => onAttachmentTap!(message, urlPreview);
      }

      final host = Uri.parse(urlPreview.titleLink!).host;
      final splitList = host.split('.');
      final hostName = splitList.length == 3 ? splitList[1] : splitList[0];
      final hostDisplayName = urlPreview.authorName?.capitalize() ??
          getWebsiteName(hostName.toLowerCase()) ??
          hostName.capitalize();

      return InkWell(
        onTap: onTap,
        child: StreamUrlAttachment(
          message: message,
          urlAttachment: urlPreview,
          hostDisplayName: hostDisplayName,
          messageTheme: messageTheme,
          constraints: constraints,
          shape: shape,
        ),
      );
    }

    Widget child;
    if (urlPreviews.length == 1) {
      child = _buildUrlPreview(urlPreviews.first);
    } else {
      child = Column(
        // Add a small vertical padding between each attachment.
        spacing: padding.vertical / 2,
        children: <Widget>[
          for (final urlPreview in urlPreviews) _buildUrlPreview(urlPreview),
        ],
      );
    }

    return Padding(
      padding: padding,
      child: child,
    );
  }
}
