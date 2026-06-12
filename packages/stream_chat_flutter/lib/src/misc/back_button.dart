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
    this.appBarBehavior,
  });

  /// Callback for when button is pressed
  final VoidCallback? onPressed;

  /// Show unread count
  final bool showUnreadCount;

  /// Channel ID used to retrieve unread count
  final String? channelId;

  /// Controls the back button's visual/layout behavior (e.g. floating vs pinned).
  /// Falls back to the theme's default when null.
  final AppBarBehavior? appBarBehavior;

  @override
  Widget build(BuildContext context) {
    final iconData = switch (Theme.of(context).platform) {
      .iOS || .macOS => context.streamIcons.chevronLeft,
      _ => context.streamIcons.arrowLeft,
    };
    final isFloating = switch (appBarBehavior ?? StreamTheme.of(context).appStyle.appBarBehavior) {
      .floating => true,
      .regular => false,
    };

    Widget button = StreamButton.icon(
      type: isFloating ? .outline : .ghost,
      isFloating: isFloating,
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
