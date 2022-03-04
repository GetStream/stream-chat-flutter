import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SendingIndicatorWrapper extends StatelessWidget {
  const SendingIndicatorWrapper({
    Key? key,
    required this.messageTheme,
    required this.message,
    required this.hasNonUrlAttachments,
    required this.streamChat,
    required this.streamChatTheme,
  }) : super(key: key);

  /// The message theme
  final MessageThemeData messageTheme;
  final Message message;
  final bool hasNonUrlAttachments;
  final StreamChatState streamChat;
  final StreamChatThemeData streamChatTheme;

  @override
  Widget build(BuildContext context) {
    final style = messageTheme.createdAtStyle;
    final memberCount = StreamChannel.of(context).channel.memberCount ?? 0;

    if (hasNonUrlAttachments &&
        (message.status == MessageSendingStatus.sending ||
            message.status == MessageSendingStatus.updating)) {
      final totalAttachments = message.attachments.length;
      final uploadRemaining =
          message.attachments.where((it) => !it.uploadState.isSuccess).length;
      if (uploadRemaining == 0) {
        return StreamSvgIcon.check(
          size: style!.fontSize,
          color: IconTheme.of(context).color!.withOpacity(0.5),
        );
      }
      return Text(
        context.translations.attachmentsUploadProgressText(
          remaining: uploadRemaining,
          total: totalAttachments,
        ),
        style: style,
      );
    }

    final channel = StreamChannel.of(context).channel;

    return BetterStreamBuilder<List<Read>>(
      stream: channel.state?.readStream,
      initialData: channel.state?.read,
      builder: (context, data) {
        final readList = data.where((it) =>
            it.user.id != streamChat.currentUser?.id &&
            (it.lastRead.isAfter(message.createdAt) ||
                it.lastRead.isAtSameMomentAs(message.createdAt)));
        final isMessageRead = readList.length >= (channel.memberCount ?? 0) - 1;
        Widget child = SendingIndicator(
          message: message,
          isMessageRead: isMessageRead,
          size: style!.fontSize,
        );
        if (isMessageRead) {
          child = Row(
            children: [
              if (memberCount > 2)
                Text(
                  readList.length.toString(),
                  style: style.copyWith(
                    color: streamChatTheme.colorTheme.accentPrimary,
                  ),
                ),
              const SizedBox(width: 2),
              child,
            ],
          );
        }
        return child;
      },
    );
  }
}
