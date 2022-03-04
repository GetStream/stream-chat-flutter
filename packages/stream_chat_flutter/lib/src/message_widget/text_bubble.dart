import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/url_attachment.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class TextBubble extends StatelessWidget {
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

  final Message message;
  final bool isOnlyEmoji;
  final EdgeInsets textPadding;

  /// Widget builder for building text
  final Widget Function(BuildContext, Message)? textBuilder;

  /// The function called when tapping on a link
  final void Function(String)? onLinkTap;

  /// Function called on mention tap
  final void Function(User)? onMentionTap;

  /// The message theme
  final MessageThemeData messageTheme;

  final bool hasUrlAttachments;
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
