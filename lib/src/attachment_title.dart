import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import 'stream_chat_theme.dart';
import 'utils.dart';

class AttachmentTitle extends StatelessWidget {
  const AttachmentTitle({
    Key key,
    @required this.attachment,
    @required this.messageTheme,
  }) : super(key: key);

  final MessageTheme messageTheme;
  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (attachment.titleLink != null) {
          launchURL(context, attachment.titleLink);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              attachment.title,
              overflow: TextOverflow.ellipsis,
              style: messageTheme.messageText.copyWith(
                color: StreamChatTheme.of(context).accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (attachment.titleLink != null || attachment.ogScrapeUrl != null)
              Text(
                Uri.parse(attachment.titleLink ?? attachment.ogScrapeUrl)
                    .authority
                    .split('.')
                    .reversed
                    .take(2)
                    .toList()
                    .reversed
                    .join('.'),
                style: messageTheme.createdAt,
              ),
          ],
        ),
      ),
    );
  }
}
