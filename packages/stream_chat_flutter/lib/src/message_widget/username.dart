import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Username extends StatelessWidget {
  const Username({
    Key? key,
    required this.message,
    required this.messageTheme,
    this.usernameBuilder,
  }) : super(key: key);

  /// Widget builder for building username
  final Widget Function(BuildContext, Message)? usernameBuilder;
  final Message message;

  /// The message theme
  final MessageThemeData messageTheme;

  @override
  Widget build(BuildContext context) {
    if (usernameBuilder != null) {
      return usernameBuilder!(context, message);
    }
    return Text(
      message.user?.name ?? '',
      maxLines: 1,
      key: key,
      style: messageTheme.messageAuthorStyle,
      overflow: TextOverflow.ellipsis,
    );
  }
}
