import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template resendMessageButton}
/// Allows a user to resend a message that has failed to be sent.
///
/// Used by [MessageActionsModal]. Should not be used by itself.
/// {@endtemplate}
class ResendMessageButton extends StatelessWidget {
  /// {@macro resendMessageButton}
  const ResendMessageButton({
    super.key,
    required this.message,
    required this.channel,
  });

  /// The message to resend.
  final Message message;

  /// The [StreamChannel] above this widget.
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final isUpdateFailed = message.status == MessageSendingStatus.failed_update;
    final streamChatThemeData = StreamChatTheme.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        if (isUpdateFailed) {
          channel.updateMessage(message);
        } else {
          channel.sendMessage(message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Row(
          children: [
            StreamSvgIcon.circleUp(
              color: streamChatThemeData.colorTheme.accentPrimary,
            ),
            const SizedBox(width: 16),
            Text(
              context.translations.toggleResendOrResendEditedMessage(
                isUpdateFailed: isUpdateFailed,
              ),
              style: streamChatThemeData.textTheme.body,
            ),
          ],
        ),
      ),
    );
  }
}
