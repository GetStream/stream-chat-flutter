import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/unread_indicator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Back button implementation
// ignore: prefer-match-file-name
class StreamBackButton extends StatelessWidget {
  /// Constructor for creating back button
  const StreamBackButton({
    Key? key,
    this.onPressed,
    this.showUnreads = false,
    this.cid,
  }) : super(key: key);

  /// Callback for when button is pressed
  final VoidCallback? onPressed;

  /// Show unread count
  final bool showUnreads;

  /// Channel cid used to retrieve unread count
  final String? cid;

  @override
  Widget build(BuildContext context) => Stack(
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
                Navigator.maybePop(context);
              }
            },
            padding: const EdgeInsets.all(14),
            child: StreamSvgIcon.left(
              size: 24,
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
            ),
          ),
          if (showUnreads)
            Positioned(
              top: 7,
              right: 7,
              child: UnreadIndicator(
                cid: cid,
              ),
            ),
        ],
      );
}
