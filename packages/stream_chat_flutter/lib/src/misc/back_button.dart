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

    Widget button = StreamButton.icon(
      type: .ghost,
      size: .medium,
      style: .secondary,
      icon: Icon(iconData),
      onPressed: () {
        if (onPressed case final onPressed?) {
          return onPressed();
        }

        Navigator.maybePop(context);
      },
    );

    if (showUnreadCount) {
      button = switch (channelId) {
        final cid? => StreamUnreadIndicator.channels(offset: .zero, cid: cid, child: button),
        _ => StreamUnreadIndicator(offset: .zero, child: button),
      };
    }

    return button;
  }
}
