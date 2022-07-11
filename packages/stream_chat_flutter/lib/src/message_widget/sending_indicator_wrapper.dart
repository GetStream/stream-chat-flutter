import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template sendingIndicatorWrapper}
/// Helper widget for building a [StreamSendingIndicator].
///
/// Used in [BottomRow]. Should not be used elsewhere.
/// {@endtemplate}
class SendingIndicatorWrapper extends StatelessWidget {
  /// {@macro sendingIndicatorWrapper}
  const SendingIndicatorWrapper({
    super.key,
    required this.messageTheme,
    required this.message,
    required this.hasNonUrlAttachments,
    required this.streamChat,
    required this.streamChatTheme,
  });

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  /// {@macro message}
  final Message message;

  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  /// {@macro streamChat}
  final StreamChatState streamChat;

  /// {@macro streamChatThemeData}
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
        Widget child = StreamSendingIndicator(
          message: message,
          isMessageRead: isMessageRead,
          size: style!.fontSize,
        );
        if (isMessageRead) {
          child = Row(
            mainAxisSize: MainAxisSize.min,
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
