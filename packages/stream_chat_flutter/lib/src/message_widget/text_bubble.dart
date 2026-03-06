import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

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
    required this.messageStyle,
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

  /// TODO: merge with messageTheme
  final core.StreamMessageStyle messageStyle;

  /// {@macro hasUrlAttachments}
  final bool hasUrlAttachments;

  /// {@macro hasQuotedMessage}
  final bool hasQuotedMessage;

  @override
  Widget build(BuildContext context) {
    if (message.text?.trim().isEmpty ?? true) return const Empty();
    return DefaultTextStyle(
      style: context.streamTextTheme.bodyDefault.copyWith(
        color: messageStyle.textColor,
        fontSize: isOnlyEmoji ? 42 : null,
      ),
      child: Padding(
        padding: isOnlyEmoji ? EdgeInsets.zero : textPadding,
        child: textBuilder != null
            ? textBuilder!(context, message)
            : StreamMessageText(
                onLinkTap: onLinkTap,
                message: message,
                onMentionTap: onMentionTap,
              ),
      ),
    );
  }
}
