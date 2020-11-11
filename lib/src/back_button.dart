import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_icons.dart';
import 'package:stream_chat_flutter/src/unread_indicator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamBackButton extends StatelessWidget {
  const StreamBackButton({
    Key key,
    this.onPressed,
    this.icon = Icons.arrow_back_ios_outlined,
    this.showUnreads = false,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final bool showUnreads;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 0,
            highlightElevation: 0,
            focusElevation: 0,
            disabledElevation: 0,
            hoverElevation: 0,
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Icon(
              icon ?? StreamIcons.left,
              size: 24,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        if (showUnreads)
          Positioned(
            top: 7,
            right: 7,
            child: UnreadIndicator(),
          ),
      ],
    );
  }
}
