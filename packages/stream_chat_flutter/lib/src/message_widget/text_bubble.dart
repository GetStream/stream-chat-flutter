import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/message_widget_content_components.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template textBubble}
/// The bubble around a [StreamMessageText].
///
/// Used in [MessageCard]. Should not be used elsewhere.
/// {@endtemplate}
class TextBubble extends StatelessWidget {
  /// {@macro textBubble}
  const TextBubble({
    super.key,
    required this.message,
    required this.isOnlyEmoji,
    required this.textPadding,
    required this.messageTheme,
    required this.hasUrlAttachments,
    required this.hasQuotedMessage,
    this.textBuilder,
    this.onLinkTap,
    this.onMentionTap,
  });

  /// {@macro message}
  final Message message;

  /// {@macro isOnlyEmoji}
  final bool isOnlyEmoji;

  /// {@macro textPadding}
  final EdgeInsets textPadding;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  /// {@macro onLinkTap}
  final void Function(String)? onLinkTap;

  /// {@macro onMentionTap}
  final void Function(User)? onMentionTap;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  /// {@macro hasUrlAttachments}
  final bool hasUrlAttachments;

  /// {@macro hasQuotedMessage}
  final bool hasQuotedMessage;

  @override
  Widget build(BuildContext context) {
    if (message.text?.trim().isEmpty ?? false) return const Offstage();
    return Padding(
      padding: isOnlyEmoji ? EdgeInsets.zero : textPadding,
      child: textBuilder != null
          ? textBuilder!(context, message)
          : StreamMessageText(
              onLinkTap: onLinkTap,
              message: message,
              onMentionTap: onMentionTap,
              messageTheme: isOnlyEmoji
                  ? messageTheme.copyWith(
                      messageTextStyle: messageTheme.messageTextStyle!.copyWith(
                        fontSize: 42,
                      ),
                    )
                  : messageTheme,
            ),
    );
  }
}
