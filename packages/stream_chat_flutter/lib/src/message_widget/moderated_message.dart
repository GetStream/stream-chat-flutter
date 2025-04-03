import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/src/utils/typedefs.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamModeratedMessage}
/// A widget that displays a message that has been moderated.
///
/// This widget is responsible for rendering messages that have been flagged or
/// moderated according to content policies. It displays either the original
/// message text (if available) or a default message indicating the content
/// was blocked.
/// {@endtemplate}
class StreamModeratedMessage extends StatelessWidget {
  /// {@macro streamModeratedMessage}
  const StreamModeratedMessage({
    super.key,
    required this.message,
    this.onMessageTap,
  });

  /// The message which got moderated by the system.
  final Message message;

  /// The action to perform when tapping on the message.
  final OnMessageTap? onMessageTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    final message = this.message.replaceMentions(linkify: false);
    final moderatedText = switch (message.text) {
      final messageText? when messageText.isNotEmpty => messageText,
      _ => context.translations.moderatedMessageBlockedText,
    };

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: switch (onMessageTap) {
          final onTap? => () => onTap(message),
          _ => null,
        },
        child: Text(
          moderatedText,
          softWrap: true,
          textAlign: TextAlign.center,
          style: theme.textTheme.captionBold.copyWith(
            color: theme.colorTheme.textLowEmphasis,
          ),
        ),
      ),
    );
  }
}
