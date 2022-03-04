import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/parse_attachments.dart';
import 'package:stream_chat_flutter/src/message_widget/quoted_message.dart';
import 'package:stream_chat_flutter/src/message_widget/text_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class QuotedMessageCard extends StatelessWidget {
  const QuotedMessageCard({
    Key? key,
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
  }) : super(key: key);

  final bool isFailedState;

  /// It controls the display behaviour of the user avatar
  final DisplayWidget showUserAvatar;

  /// The shape of the message text
  final ShapeBorder? shape;

  /// The borderside of the message text
  final BorderSide? borderSide;

  /// The message theme
  final MessageThemeData messageTheme;

  /// The border radius of the message text
  final BorderRadiusGeometry? borderRadiusGeometry;

  final bool hasQuotedMessage;
  final bool hasUrlAttachments;
  final bool hasNonUrlAttachments;
  final bool isOnlyEmoji;
  final bool isGiphy;
  final Message message;

  /// Builder for respective attachment types
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// The internal padding of an attachment
  final EdgeInsetsGeometry attachmentPadding;

  /// The internal padding of the message text
  final EdgeInsets textPadding;

  /// Widget builder for building text
  final Widget Function(BuildContext, Message)? textBuilder;

  /// The function called when tapping on a link
  final void Function(String)? onLinkTap;

  /// Function called on mention tap
  final void Function(User)? onMentionTap;

  /// Function called when quotedMessage is tapped
  final OnQuotedMessageTap? onQuotedMessageTap;
  final bool reverse;

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
          if (!isGiphy)
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
