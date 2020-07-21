import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat/stream_chat.dart';

import 'stream_chat_theme.dart';
import 'utils.dart';

class MessageText extends StatelessWidget {
  const MessageText({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.onMentionTap,
  }) : super(key: key);

  final Message message;
  final void Function(User) onMentionTap;
  final MessageTheme messageTheme;

  @override
  Widget build(BuildContext context) {
    final text = _replaceMentions(message.text);
    return MarkdownBody(
      data: text,
      onTapLink: (link) {
        if (link.startsWith('@')) {
          final mentionedUser = message.mentionedUsers.firstWhere(
            (u) => '@${u.name.replaceAll(' ', '')}' == link,
            orElse: () => null,
          );

          if (onMentionTap != null) {
            onMentionTap(mentionedUser);
          } else {
            print('tap on ${mentionedUser.name}');
          }
        } else {
          launchURL(context, link);
        }
      },
      styleSheet: MarkdownStyleSheet.fromTheme(
        Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: messageTheme.messageText.color,
                decoration: messageTheme.messageText.decoration,
                decorationColor: messageTheme.messageText.decorationColor,
                decorationStyle: messageTheme.messageText.decorationStyle,
                fontFamily: messageTheme.messageText.fontFamily,
              ),
        ),
      ).copyWith(
        a: messageTheme.messageLinks,
        p: messageTheme.messageText,
      ),
    );
  }

  String _replaceMentions(String text) {
    message.mentionedUsers?.forEach((u) {
      text = text.replaceAll(
          '@${u.name}', '[@${u.name}](@${u.name.replaceAll(' ', '')})');
    });
    return text;
  }
}
