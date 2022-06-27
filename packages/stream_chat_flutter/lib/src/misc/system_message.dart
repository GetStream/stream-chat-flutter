import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro streamSystemMessage}
@Deprecated("Use 'StreamSystemMessage' instead")
typedef SystemMessage = StreamSystemMessage;

/// {@template streamSystemMessage}
/// Shows a date divider depending on the date difference
/// FIXME: This is NOT a good description!
/// {@endtemplate}
class StreamSystemMessage extends StatelessWidget {
  /// {@macro streamSystemMessage}
  const StreamSystemMessage({
    super.key,
    required this.message,
    this.onMessageTap,
  });

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
      onTap: onMessageTap == null ? null : () => onMessageTap!(message),
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
