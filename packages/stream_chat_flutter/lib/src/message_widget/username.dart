import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template username}
/// Displays the username of a particular message's sender.
/// {@endtemplate}
class Username extends StatelessWidget {
  /// {@macro username}
  const Username({
    super.key,
    required this.message,
    required this.messageTheme,
    this.usernameBuilder,
  });

  /// {@macro usernameBuilder}
  final Widget Function(BuildContext, Message)? usernameBuilder;

  /// {@macro message}
  final Message message;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

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
