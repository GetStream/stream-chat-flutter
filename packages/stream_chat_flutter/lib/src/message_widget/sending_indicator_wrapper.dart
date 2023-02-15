import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template sendingIndicatorWrapper}
/// Helper widget for building a [StreamSendingIndicator].
///
/// Used in [BottomRow]. Should not be used elsewhere.
/// {@endtemplate}
class SendingIndicatorBuilder extends StatelessWidget {
  /// {@macro sendingIndicatorWrapper}
  const SendingIndicatorBuilder({
    super.key,
    required this.messageTheme,
    required this.message,
    required this.hasNonUrlAttachments,
    required this.streamChat,
    required this.streamChatTheme,
    this.channel,
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

  /// {@macro channel}
  final Channel? channel;

  @override
  Widget build(BuildContext context) {
    final style = messageTheme.createdAtStyle;
    final thisChannel = channel ?? StreamChannel.of(context).channel;
    final memberCount = thisChannel.memberCount ?? 0;

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

    return BetterStreamBuilder<List<Read>>(
      stream: thisChannel.state?.readStream,
      initialData: thisChannel.state?.read,
      builder: (context, data) {
        final readList = data.where((it) =>
            it.user.id != streamChat.currentUser?.id &&
            (it.lastRead.isAfter(message.createdAt) ||
                it.lastRead.isAtSameMomentAs(message.createdAt)));

        final isMessageRead = readList.isNotEmpty;
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
