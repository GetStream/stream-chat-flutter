import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template messageCard}
/// The widget containing a quoted message.
///
/// Used in [MessageWidgetContent]. Should not be used elsewhere.
/// {@endtemplate}
class MessageCard extends StatelessWidget {
  /// {@macro messageCard}
  const MessageCard({
    super.key,
    required this.message,
    required this.isFailedState,
    required this.showUserAvatar,
    required this.messageTheme,
    required this.hasQuotedMessage,
    required this.hasUrlAttachments,
    required this.hasNonUrlAttachments,
    required this.isOnlyEmoji,
    required this.isGiphy,
    required this.attachmentBuilders,
    required this.attachmentPadding,
    required this.textPadding,
    required this.reverse,
    this.shape,
    this.borderSide,
    this.borderRadiusGeometry,
    this.textBuilder,
    this.onLinkTap,
    this.onMentionTap,
    this.onQuotedMessageTap,
  });

  /// {@macro isFailedState}
  final bool isFailedState;

  /// {@macro showUserAvatar}
  final DisplayWidget showUserAvatar;

  /// {@macro shape}
  final ShapeBorder? shape;

  /// {@macro borderSide}
  final BorderSide? borderSide;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  /// {@macro borderRadiusGeometry}
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// {@macro hasQuotedMessage}
  final bool hasQuotedMessage;

  /// {@macro hasUrlAttachments}
  final bool hasUrlAttachments;

  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  /// {@macro isOnlyEmoji}
  final bool isOnlyEmoji;

  /// {@macro isGiphy}
  final bool isGiphy;

  /// {@macro message}
  final Message message;

  /// {@macro attachmentBuilders}
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// {@macro attachmentPadding}
  final EdgeInsetsGeometry attachmentPadding;

  /// {@macro textPadding}
  final EdgeInsets textPadding;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  /// {@macro onLinkTap}
  final void Function(String)? onLinkTap;

  /// {@macro onMentionTap}
  final void Function(User)? onMentionTap;

  /// {@macro onQuotedMessageTap}
  final OnQuotedMessageTap? onQuotedMessageTap;

  /// {@macro reverse}
  final bool reverse;

  /// Whether the message is a long text-only message.
  bool get isLongTextMessage =>
      !hasUrlAttachments &&
      !hasNonUrlAttachments &&
      message.text != null &&
      message.text!.length > 100;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      margin: EdgeInsets.symmetric(
        horizontal: (isFailedState ? 15.0 : 0.0) +
            // ignore: lines_longer_than_80_chars
            (showUserAvatar == DisplayWidget.gone ? 0 : 4.0),
      ),
      shape: shape ??
          RoundedRectangleBorder(
            side: borderSide ??
                BorderSide(
                  color: messageTheme.messageBorderColor ?? Colors.grey,
                ),
            borderRadius: borderRadiusGeometry ?? BorderRadius.zero,
          ),
      color: _getBackgroundColor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasQuotedMessage)
            QuotedMessage(
              reverse: reverse,
              message: message,
              hasNonUrlAttachments: hasNonUrlAttachments,
              onQuotedMessageTap: onQuotedMessageTap,
            ),
          if (hasNonUrlAttachments)
            ParseAttachments(
              message: message,
              attachmentBuilders: attachmentBuilders,
              attachmentPadding: attachmentPadding,
            ),
          if (!isGiphy && !isLongTextMessage)
            TextBubble(
              messageTheme: messageTheme,
              message: message,
              textPadding: textPadding,
              textBuilder: textBuilder,
              isOnlyEmoji: isOnlyEmoji,
              hasQuotedMessage: hasQuotedMessage,
              hasUrlAttachments: hasUrlAttachments,
              onLinkTap: onLinkTap,
              onMentionTap: onMentionTap,
            ),
          if (!isGiphy && isLongTextMessage)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.35,
              ),
              child: TextBubble(
                messageTheme: messageTheme,
                message: message,
                textPadding: textPadding,
                textBuilder: textBuilder,
                isOnlyEmoji: isOnlyEmoji,
                hasQuotedMessage: hasQuotedMessage,
                hasUrlAttachments: hasUrlAttachments,
                onLinkTap: onLinkTap,
                onMentionTap: onMentionTap,
              ),
            ),
        ],
      ),
    );
  }

  Color? _getBackgroundColor() {
    if (hasQuotedMessage) {
      return messageTheme.messageBackgroundColor;
    }

    if (hasUrlAttachments) {
      return messageTheme.linkBackgroundColor;
    }

    if (isOnlyEmoji) {
      return Colors.transparent;
    }

    if (isGiphy) {
      return Colors.transparent;
    }

    return messageTheme.messageBackgroundColor;
  }
}
