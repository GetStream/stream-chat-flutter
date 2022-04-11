import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro attachmentTitle}
@Deprecated("Use 'StreamAttachmentTitle' instead")
typedef AttachmentTitle = StreamAttachmentTitle;

/// {@template attachmentTitle}
/// Title for attachments
/// {@endtemplate}
class StreamAttachmentTitle extends StatelessWidget {
  /// {@macro attachmentTitle}
  const StreamAttachmentTitle({
    Key? key,
    required this.attachment,
    required this.messageTheme,
  }) : super(key: key);

  /// Theme to apply to text
  final StreamMessageThemeData messageTheme;

  /// Attachment data to display
  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final normalizedTitleLink = attachment.titleLink?.replaceFirst(
      RegExp(r'https?://(www\.)?'),
      '',
    );
    return GestureDetector(
      onTap: () {
        final titleLink = attachment.titleLink;
        if (titleLink != null) launchURL(context, titleLink);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (attachment.title != null)
              Text(
                attachment.title!,
                overflow: TextOverflow.ellipsis,
                style: messageTheme.messageTextStyle?.copyWith(
                  color: StreamChatTheme.of(context).colorTheme.accentPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (normalizedTitleLink != null)
              Text(normalizedTitleLink, style: messageTheme.messageTextStyle),
          ],
        ),
      ),
    );
  }
}
