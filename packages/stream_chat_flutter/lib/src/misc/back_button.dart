import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamBackButton}
/// A custom back button implementation
/// {@endtemplate}
class StreamBackButton extends StatelessWidget {
  /// {@macro streamBackButton}
  const StreamBackButton({
    super.key,
    this.onPressed,
    this.showUnreadCount = false,
    this.channelId,
  });

  /// Callback for when button is pressed
  final VoidCallback? onPressed;

  /// Show unread count
  final bool showUnreadCount;

  /// Channel ID used to retrieve unread count
  final String? channelId;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    Widget icon = StreamSvgIcon.left(
      size: 24,
      color: theme.colorTheme.textHighEmphasis,
    );

    if (showUnreadCount) {
      icon = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          icon,
          PositionedDirectional(
            top: -4,
            start: 12,
            child: StreamUnreadIndicator(cid: channelId),
          ),
        ],
      );
    }

    return IconButton(
      icon: icon,
      onPressed: () {
        if (onPressed case final onPressed?) {
          return onPressed();
        }

        Navigator.maybePop(context);
      },
    );
  }
}
