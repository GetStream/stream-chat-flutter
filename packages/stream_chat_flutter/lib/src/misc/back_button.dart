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
    final iconData = switch (Theme.of(context).platform) {
      .iOS || .macOS => context.streamIcons.chevronLeft,
      _ => context.streamIcons.arrowLeft,
    };

    Widget icon = Icon(iconData);
    if (showUnreadCount) {
      icon = switch (channelId) {
        final cid? => StreamUnreadIndicator.channels(cid: cid, child: icon),
        _ => StreamUnreadIndicator(child: icon),
      };
    }

    return StreamButton.icon(
      type: .ghost,
      size: .medium,
      style: .secondary,
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
