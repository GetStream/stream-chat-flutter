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
    final channel = this.channel ?? StreamChannel.of(context).channel;
    final memberCount = channel.memberCount ?? 0;

    if (hasNonUrlAttachments && message.state.isOutgoing) {
      final totalAttachments = message.attachments.length;
      final attachmentsToUpload = message.attachments.where((it) {
        return !it.uploadState.isSuccess;
      });

      if (attachmentsToUpload.isNotEmpty) {
        return Text(
          context.translations.attachmentsUploadProgressText(
            remaining: attachmentsToUpload.length,
            total: totalAttachments,
          ),
          style: style,
        );
      }
    }

    return BetterStreamBuilder<List<Read>>(
      stream: channel.state?.readStream,
      initialData: channel.state?.read,
      builder: (context, data) {
        final readList = data.where((it) =>
            it.user.id != streamChat.currentUser?.id &&
            (it.lastRead.isAfter(message.createdAt) ||
                it.lastRead.isAtSameMomentAs(message.createdAt)));

        final isMessageRead = readList.isNotEmpty;
        Widget child = StreamSendingIndicator(
          message: message,
          isMessageRead: isMessageRead,
          size: style?.fontSize,
        );

        if (isMessageRead) {
          child = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (memberCount > 2)
                Text(
                  readList.length.toString(),
                  style: style?.copyWith(
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
