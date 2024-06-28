import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamUrlAttachment}
/// Displays a URL attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamUrlAttachment extends StatelessWidget {
  /// {@macro streamUrlAttachment}
  const StreamUrlAttachment({
    super.key,
    required this.message,
    required this.urlAttachment,
    required this.hostDisplayName,
    required this.messageTheme,
    this.shape,
    this.constraints = const BoxConstraints(),
  });

  /// The [Message] that the image is attached to.
  final Message message;

  /// Attachment to be displayed
  final Attachment urlAttachment;

  /// The shape of the attachment.
  ///
  /// Defaults to [RoundedRectangleBorder] with a radius of 14.
  final ShapeBorder? shape;

  /// The constraints to use when displaying the file.
  final BoxConstraints constraints;

  /// Host name
  final String hostDisplayName;

  /// The [StreamMessageThemeData] to use for the image title
  final StreamMessageThemeData messageTheme;

  @override
  Widget build(BuildContext context) {
    final chatTheme = StreamChatTheme.of(context);
    final colorTheme = chatTheme.colorTheme;
    final shape = this.shape ??
        RoundedRectangleBorder(
          side: BorderSide(
            color: colorTheme.borders,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(8),
        );

    final backgroundColor = messageTheme.urlAttachmentBackgroundColor;

    return Container(
      constraints: constraints,
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(
        shape: shape,
        color: backgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
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
              Positioned(
                left: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                    ),
                    color: backgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 8,
                      right: 12,
                      bottom: 4,
                    ),
                    child: Text(
                      hostDisplayName,
                      style: messageTheme.urlAttachmentHostStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (urlAttachment.title != null)
                  Builder(builder: (context) {
                    final maxLines = messageTheme.urlAttachmentTitleMaxLine;

                    TextOverflow? overflow;
                    if (maxLines != null && maxLines > 0) {
                      overflow = TextOverflow.ellipsis;
                    }

                    return Text(
                      urlAttachment.title!.trim(),
                      maxLines: maxLines,
                      overflow: overflow,
                      style: messageTheme.urlAttachmentTitleStyle,
                    );
                  }),
                if (urlAttachment.text != null)
                  Builder(builder: (context) {
                    final maxLines = messageTheme.urlAttachmentTextMaxLine;

                    TextOverflow? overflow;
                    if (maxLines != null && maxLines > 0) {
                      overflow = TextOverflow.ellipsis;
                    }

                    return Text(
                      urlAttachment.text!,
                      maxLines: maxLines,
                      overflow: overflow,
                      style: messageTheme.urlAttachmentTextStyle,
                    );
                  }),
              ].insertBetween(const SizedBox(height: 4)),
            ),
          ),
        ],
      ),
    );
  }
}
