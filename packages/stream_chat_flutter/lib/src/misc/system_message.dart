import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template systemMessage}
/// Shows a date divider depending on the date difference
/// FIXME: This is NOT a good description!
/// {@endtemplate}
class SystemMessage extends StatelessWidget {
  /// {@macro systemMessage}
  const SystemMessage({
    Key? key,
    required this.message,
    this.onMessageTap,
  }) : super(key: key);

  /// This message
  /// FIXME: This is NOT a good description!
  final Message message;

  /// The action to perform when tapping on the message.
  final void Function(Message)? onMessageTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onMessageTap != null) {
          onMessageTap!(message);
        }
      },
      child: Text(
        message.text!,
        textAlign: TextAlign.center,
        softWrap: true,
        style: theme.textTheme.captionBold.copyWith(
          color: theme.colorTheme.textLowEmphasis,
        ),
      ),
    );
  }
}
