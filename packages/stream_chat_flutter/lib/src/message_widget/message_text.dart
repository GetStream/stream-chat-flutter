import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
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
        final messageText = message.translate(language).replaceMentions().text?.replaceAll('\n', '\n\n').trim();

        return StreamMarkdownMessage(
          data: messageText ?? '',
          messageTheme: messageTheme,
          selectable: isDesktopDeviceOrWeb,
          onTapLink:
              (
                String text,
                String? href,
                String title,
              ) {
                if (text.startsWith('@')) {
                  final mentionedUser = message.mentionedUsers.firstWhereOrNull(
                    (u) => '@${u.name}' == text,
                  );

                  if (mentionedUser == null) return;

                  onMentionTap?.call(mentionedUser);
                } else if (href != null) {
                  if (onLinkTap != null) {
                    onLinkTap!(href);
                  } else {
                    launchURL(context, href);
                  }
                }
              },
        );
      },
    );
  }
}
