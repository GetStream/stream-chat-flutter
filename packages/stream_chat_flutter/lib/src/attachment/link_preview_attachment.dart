import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A link preview attachment with Open Graph metadata.
///
/// [StreamLinkPreviewAttachment] presents a link preview, showing the
/// page's image, title, and description.
///
/// {@tool snippet}
///
/// Basic usage:
///
/// ```dart
/// StreamLinkPreviewAttachment(
///   message: message,
///   urlAttachment: urlAttachment,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamLinkPreviewAttachmentProps], which configures this widget.
///  * [DefaultStreamLinkPreviewAttachment], the default implementation.
class StreamLinkPreviewAttachment extends StatelessWidget {
  /// Creates a [StreamLinkPreviewAttachment].
  StreamLinkPreviewAttachment({
    super.key,
    required Message message,
    required Attachment urlAttachment,
    BoxConstraints? constraints,
  }) : props = .new(
         message: message,
         urlAttachment: urlAttachment,
         constraints: constraints,
       );

  /// The properties that configure this attachment.
  final StreamLinkPreviewAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamLinkPreviewAttachmentProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamLinkPreviewAttachment(props: props);
  }
}

/// Properties for configuring a [StreamLinkPreviewAttachment].
///
/// This class holds all the configuration options for a link preview
/// attachment, allowing them to be passed through the [StreamComponentFactory].
///
/// See also:
///
///  * [StreamLinkPreviewAttachment], which uses these properties.
///  * [DefaultStreamLinkPreviewAttachment], the default implementation.
class StreamLinkPreviewAttachmentProps {
  /// Creates properties for a link preview attachment.
  const StreamLinkPreviewAttachmentProps({
    required this.message,
    required this.urlAttachment,
    this.constraints,
  });

  /// The [Message] that the image is attached to.
  final Message message;

  /// Attachment to be displayed.
  final Attachment urlAttachment;

  /// The constraints to use when displaying the link preview.
  final BoxConstraints? constraints;
}

const _kDefaultConstraints = BoxConstraints(maxWidth: 256);

/// The default implementation of [StreamLinkPreviewAttachment].
///
/// Renders the Open Graph preview with host name, title, and description.
///
/// See also:
///
///  * [StreamLinkPreviewAttachment], the public API widget.
///  * [StreamLinkPreviewAttachmentProps], which configures this widget.
class DefaultStreamLinkPreviewAttachment extends StatelessWidget {
  /// Creates a default Stream link preview attachment.
  const DefaultStreamLinkPreviewAttachment({
    super.key,
    required this.props,
  });

  /// The properties that configure this attachment.
  final StreamLinkPreviewAttachmentProps props;

  @override
  Widget build(BuildContext context) {
    final urlAttachment = props.urlAttachment;

    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final constraints = props.constraints ?? _kDefaultConstraints;

    return ConstrainedBox(
      constraints: constraints,
      child: Column(
        mainAxisSize: .min,
        children: [
          AspectRatio(
            // Default aspect ratio for Open Graph images.
            // https://www.kapwing.com/resources/what-is-an-og-image-make-and-format-og-images-for-your-blog-or-webpage
            aspectRatio: 1.91 / 1,
            child: StreamImageAttachmentThumbnail(
              image: urlAttachment,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: .all(spacing.sm),
            child: Column(
              spacing: spacing.xxs,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (urlAttachment.title case final title?)
                  Text(
                    title.trim(),
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: textTheme.captionEmphasis.copyWith(
                      color: colorScheme.textPrimary,
                    ),
                  ),
                if (urlAttachment.text case final text?)
                  Text(
                    text,
                    maxLines: 3,
                    overflow: .ellipsis,
                    style: textTheme.metadataDefault.copyWith(
                      color: colorScheme.textPrimary,
                    ),
                  ),
                if (urlAttachment.titleLink case final titleLink?)
                  Row(
                    mainAxisSize: .min,
                    spacing: spacing.xxs,
                    children: [
                      Icon(icons.link, size: 12),
                      Expanded(
                        child: Text(
                          titleLink,
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: textTheme.metadataDefault.copyWith(
                            color: colorScheme.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
