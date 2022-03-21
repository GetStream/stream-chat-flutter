import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/message_widget_content_components.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template textBubble}
/// The bubble around a [MessageText].
///
/// Used in [MessageCard]. Should not be used elsewhere.
/// {@endtemplate}
class TextBubble extends StatelessWidget {
  /// {@macro textBubble}
  const TextBubble({
    Key? key,
    required this.message,
    required this.isOnlyEmoji,
    required this.textPadding,
    required this.messageTheme,
    required this.hasUrlAttachments,
    required this.hasQuotedMessage,
    this.textBuilder,
    this.onLinkTap,
    this.onMentionTap,
  }) : super(key: key);

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
  final MessageThemeData messageTheme;

  /// {@macro hasUrlAttachments}
  final bool hasUrlAttachments;

  /// {@macro hasQuotedMessage}
  final bool hasQuotedMessage;

  @override
  Widget build(BuildContext context) {
    if (message.text?.trim().isEmpty ?? false) return const Offstage();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: isOnlyEmoji ? EdgeInsets.zero : textPadding,
          child: textBuilder != null
              ? textBuilder!(context, message)
              : MessageText(
                  onLinkTap: onLinkTap,
                  message: message,
                  onMentionTap: onMentionTap,
                  messageTheme: isOnlyEmoji
                      ? messageTheme.copyWith(
                          messageTextStyle:
                              messageTheme.messageTextStyle!.copyWith(
                            fontSize: 42,
                          ),
                        )
                      : messageTheme,
                ),
        ),
        if (hasUrlAttachments && !hasQuotedMessage) _buildUrlAttachment(),
      ],
    );
  }

  Widget _buildUrlAttachment() {
    final urlAttachment =
        message.attachments.firstWhere((element) => element.titleLink != null);

    final host = Uri.parse(urlAttachment.titleLink!).host;
    final splitList = host.split('.');
    final hostName = splitList.length == 3 ? splitList[1] : splitList[0];
    final hostDisplayName = urlAttachment.authorName?.capitalize() ??
        getWebsiteName(hostName.toLowerCase()) ??
        hostName.capitalize();

    return UrlAttachment(
      urlAttachment: urlAttachment,
      hostDisplayName: hostDisplayName,
      textPadding: textPadding,
      messageTheme: messageTheme,
    );
  }
}
