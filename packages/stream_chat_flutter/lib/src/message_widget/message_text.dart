import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamMessageText}
/// The text content of a message.
/// {@endtemplate}
class StreamMessageText extends StatelessWidget {
  /// {@macro streamMessageText}
  const StreamMessageText({
    super.key,
    required this.message,
    required this.messageTheme,
    this.onMentionTap,
    this.onLinkTap,
  });

  /// Message whose text is to be displayed
  final Message message;

  /// The action to perform when a mention is tapped
  final void Function(User)? onMentionTap;

  /// The action to perform when a link is tapped
  final void Function(String)? onLinkTap;

  /// [StreamMessageThemeData] whose text theme is to be applied
  final StreamMessageThemeData messageTheme;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    assert(streamChat.currentUser != null, '');
    return BetterStreamBuilder<String>(
      stream: streamChat.currentUserStream.map((it) => it!.language ?? 'en'),
      initialData: streamChat.currentUser!.language ?? 'en',
      builder: (context, language) {
        final messageText = message
            .translate(language)
            .replaceMentions()
            .text
            ?.replaceAll('\n', '\n\n');
        final themeData = Theme.of(context);
        return MarkdownBody(
          data: messageText ?? '',
          selectable: isDesktopDeviceOrWeb,
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
}
