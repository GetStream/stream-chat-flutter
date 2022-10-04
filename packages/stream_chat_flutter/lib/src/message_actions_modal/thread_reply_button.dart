import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template threadReplyButton}
/// Allows a user to start a thread reply to a message.
///
/// Used by [MessageActionsModal]. Should not be used by itself.
/// {@endtemplate}
class ThreadReplyButton extends StatelessWidget {
  /// {@macro threadReplyButton}
  const ThreadReplyButton({
    super.key,
    required this.message,
    this.onThreadReplyTap,
  });

  /// The message to start a thread reply to.
  final Message message;

  /// The action to perform when "thread reply" is tapped
  final OnMessageTap? onThreadReplyTap;

  @override
  Widget build(BuildContext context) {
    final streamChatThemeData = StreamChatTheme.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        if (onThreadReplyTap != null) {
          onThreadReplyTap?.call(message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Row(
          children: [
            StreamSvgIcon.thread(
              color: streamChatThemeData.primaryIconTheme.color,
            ),
            const SizedBox(width: 16),
            Text(
              context.translations.threadReplyLabel,
              style: streamChatThemeData.textTheme.body,
            ),
          ],
        ),
      ),
    );
  }
}
