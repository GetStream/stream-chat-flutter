import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Title for attachments
class AttachmentTitle extends StatelessWidget {
  /// Supply attachment and theme for constructing title
  const AttachmentTitle({
    Key? key,
    required this.attachment,
    required this.messageTheme,
  }) : super(key: key);

  /// Theme to apply to text
  final MessageThemeData messageTheme;

  /// Attachment data to display
  final Attachment attachment;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (attachment.titleLink != null) {
            launchURL(context, attachment.titleLink);
          }
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
              if (attachment.titleLink != null ||
                  attachment.ogScrapeUrl != null)
                Text(
                  Uri.parse(attachment.titleLink ?? attachment.ogScrapeUrl!)
                      .authority
                      .split('.')
                      .reversed
                      .take(2)
                      .toList()
                      .reversed
                      .join('.'),
                  style: messageTheme.messageTextStyle,
                ),
            ],
          ),
        ),
      );
}
