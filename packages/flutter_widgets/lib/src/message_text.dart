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
    this.onLinkTap,
  }) : super(key: key);

  final Message message;
  final void Function(User) onMentionTap;
  final void Function(String) onLinkTap;
  final MessageTheme messageTheme;

  @override
  Widget build(BuildContext context) {
    final text = _replaceMentions(message.text);
    return MarkdownBody(
      data: text,
      onTapLink: (
        String link,
        String href,
        String title,
      ) {
        if (link.startsWith('@')) {
          final mentionedUser = message.mentionedUsers.firstWhere(
            (u) => '@${u.name}' == link,
            orElse: () => null,
          );

          if (onMentionTap != null) {
            onMentionTap(mentionedUser);
          } else {
            print('tap on ${mentionedUser.name}');
          }
        } else {
          if (onLinkTap != null) {
            onLinkTap(link);
          } else {
            launchURL(context, link);
          }
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
    message.mentionedUsers?.map((u) => u.name)?.toSet()?.forEach((userName) {
      text = text.replaceAll(
          '@${userName}', '[@${userName}](@${userName.replaceAll(' ', '')})');
    });
    return text;
  }
}
