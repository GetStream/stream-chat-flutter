import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

class DeletedMessage extends StatelessWidget {
  const DeletedMessage({
    Key key,
    @required this.messageTheme,
    this.borderRadiusGeometry,
    this.shape,
    this.borderSide,
    this.reverse = false,
  }) : super(key: key);

  /// The theme of the message
  final MessageTheme messageTheme;

  /// The border radius of the message text
  final BorderRadiusGeometry borderRadiusGeometry;

  /// The shape of the message text
  final ShapeBorder shape;

  /// The borderside of the message text
  final BorderSide borderSide;

  /// If true the widget will be mirrored
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationY(reverse ? pi : 0),
      alignment: Alignment.center,
      child: Material(
        color: messageTheme.messageBackgroundColor,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: borderRadiusGeometry ?? BorderRadius.zero,
              side: borderSide ??
                  BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withAlpha(24)
                        : Colors.black.withAlpha(24),
                  ),
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16,
          ),
          child: Transform(
            transform: Matrix4.rotationY(reverse ? pi : 0),
            alignment: Alignment.center,
            child: Text(
              'Message deleted',
              style: messageTheme.messageText.copyWith(
                fontStyle: FontStyle.italic,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                    .withOpacity(.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
