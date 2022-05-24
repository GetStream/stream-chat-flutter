import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamBackButton}
/// A custom back button implementation
/// {@endtemplate}
// ignore: prefer-match-file-name
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
    return Stack(
      alignment: Alignment.center,
      children: [
        RawMaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          onPressed: () {
            if (onPressed != null) {
              onPressed!();
            } else {
              Navigator.of(context).maybePop();
            }
          },
          padding: const EdgeInsets.all(14),
          child: StreamSvgIcon.left(
            size: 24,
            color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
          ),
        ),
        if (showUnreadCount)
          Positioned(
            top: 7,
            right: 7,
            child: StreamUnreadIndicator(
              cid: channelId,
            ),
          ),
      ],
    );
  }
}
