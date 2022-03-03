import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Allows a user to start a thread reply to a message.
///
/// Used by [MessageActionsModal]. Should not be used by itself.
class ThreadReplyButton extends StatelessWidget {
  /// Builds a [ThreadReplyButton].
  const ThreadReplyButton({
    Key? key,
    required this.message,
    this.onThreadReplyTap,
  }) : super(key: key);

  /// The message to start a thread reply to.
  final Message message;

  /// Callback for when thread reply is tapped
  final OnMessageTap? onThreadReplyTap;

  @override
  Widget build(BuildContext context) {
    final streamChatThemeData = StreamChatTheme.of(context);
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (onThreadReplyTap != null) {
          onThreadReplyTap!(message);
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
