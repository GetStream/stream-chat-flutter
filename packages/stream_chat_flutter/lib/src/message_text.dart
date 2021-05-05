import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../stream_chat_flutter.dart';

/// Text widget to display in message
class MessageText extends StatelessWidget {
  /// Constructor for creating a [MessageText] widget
  const MessageText({
    Key? key,
    required this.message,
    required this.messageTheme,
    this.onMentionTap,
    this.onLinkTap,
  }) : super(key: key);

  /// Message whose text is to be displayed
  final Message message;

  /// Callback for when mention is tapped
  final void Function(User)? onMentionTap;

  /// Callback for when link is tapped
  final void Function(String)? onLinkTap;

  /// [MessageTheme] whose text theme is to be applied
  final MessageTheme messageTheme;

  @override
  Widget build(BuildContext context) {
    final text = _replaceMentions(message.text ?? '').replaceAll('\n', '\\\n');

    return MarkdownBody(
      data: text,
      onTapLink: (
        String link,
        String? href,
        String title,
      ) {
        if (link.startsWith('@')) {
          final mentionedUser = message.mentionedUsers.firstWhereOrNull(
            (u) => '@${u.name}' == link,
          );
          if (mentionedUser == null) {
            return;
          }

          if (onMentionTap != null) {
            onMentionTap!(mentionedUser);
          } else {
            print('tap on ${mentionedUser.name}');
          }
        } else {
          if (onLinkTap != null) {
            onLinkTap!(link);
          } else {
            launchURL(context, link);
          }
        }
      },
      styleSheet: MarkdownStyleSheet.fromTheme(
        Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: messageTheme.messageText?.color,
                decoration: messageTheme.messageText?.decoration,
                decorationColor: messageTheme.messageText?.decorationColor,
                decorationStyle: messageTheme.messageText?.decorationStyle,
                fontFamily: messageTheme.messageText?.fontFamily,
              ),
        ),
      ).copyWith(
        a: messageTheme.messageLinks,
        p: messageTheme.messageText,
      ),
    );
  }

  String _replaceMentions(String text) {
    message.mentionedUsers.map((u) => u.name).toSet().forEach((userName) {
      // ignore: parameter_assignments
      text = text.replaceAll(
          '@$userName', '[@$userName](@${userName.replaceAll(' ', '')})');
    });
    return text;
  }
}
