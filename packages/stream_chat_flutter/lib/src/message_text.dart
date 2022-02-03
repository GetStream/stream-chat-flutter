import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

  /// [MessageThemeData] whose text theme is to be applied
  final MessageThemeData messageTheme;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    assert(streamChat.currentUser != null, '');
    return BetterStreamBuilder<String>(
      stream: streamChat.currentUserStream.map((it) => it!.language ?? 'en'),
      initialData: streamChat.currentUser!.language ?? 'en',
      builder: (context, language) {
        final translatedText =
            message.i18n?['${language}_text'] ?? message.text;
        final messageText =
            _replaceMentions(translatedText ?? '').replaceAll('\n', '\n\n');
        final themeData = Theme.of(context);
        return MarkdownBody(
          data: messageText,
          onTapLink: (
            String link,
            String? href,
            String title,
          ) {
            if (link.startsWith('@')) {
              final mentionedUser = message.mentionedUsers.firstWhereOrNull(
                (u) => '@${u.name}' == link,
              );

              if (mentionedUser == null) return;

              onMentionTap?.call(mentionedUser);
            } else {
              if (onLinkTap != null) {
                onLinkTap!(link);
              } else {
                launchURL(context, link);
              }
            }
          },
          styleSheet: MarkdownStyleSheet.fromTheme(
            themeData.copyWith(
              textTheme: themeData.textTheme.apply(
                bodyColor: messageTheme.messageTextStyle?.color,
                decoration: messageTheme.messageTextStyle?.decoration,
                decorationColor: messageTheme.messageTextStyle?.decorationColor,
                decorationStyle: messageTheme.messageTextStyle?.decorationStyle,
                fontFamily: messageTheme.messageTextStyle?.fontFamily,
              ),
            ),
          ).copyWith(
            a: messageTheme.messageLinksStyle,
            p: messageTheme.messageTextStyle,
          ),
        );
      },
    );
  }

  String _replaceMentions(String text) {
    var messageTextToRender = text;
    for (final user in message.mentionedUsers.toSet()) {
      final userName = user.name;
      messageTextToRender = messageTextToRender.replaceAll(
        '@$userName',
        '[@$userName](@${userName.replaceAll(' ', '')})',
      );
    }
    return messageTextToRender;
  }
}
