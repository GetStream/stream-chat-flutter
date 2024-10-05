import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/quoted_message_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template quotedMessage}
/// A quoted message in a chat.
///
/// Used in [QuotedMessageCard]. Should not be used elsewhere.
/// {@endtemplate}
class QuotedMessage extends StatelessWidget {
  /// {@macro quotedMessage}
  const QuotedMessage({
    super.key,
    required this.message,
    required this.hasNonUrlAttachments,
    this.textBuilder,
  });

  /// {@macro message}
  final Message message;

  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    final chatThemeData = StreamChatTheme.of(context);

    final isMyMessage = message.user?.id == streamChat.currentUser?.id;
    final isMyQuotedMessage =
        message.quotedMessage?.user?.id == streamChat.currentUser?.id;
    return StreamQuotedMessageWidget(
      isMyMessage: isMyMessage,
      message: message.quotedMessage!,
      messageTheme: isMyMessage
          ? chatThemeData.otherMessageTheme
          : chatThemeData.ownMessageTheme,
      reverse: !isMyQuotedMessage,
      textBuilder: textBuilder,
      padding: EdgeInsets.only(
        right: 8,
        left: 8,
        top: 8,
        bottom: hasNonUrlAttachments ? 8 : 0,
      ),
    );
  }
}
