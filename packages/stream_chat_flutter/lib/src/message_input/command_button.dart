import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';

/// {@template commandButton}
/// The button that allows a user to use commands in a chat.
/// {@endtemplate}
class CommandButton extends StatelessWidget {
  /// {@macro commandButton}
  const CommandButton({
    super.key,
    required this.color,
    required this.onPressed,
  });

  /// The color of the button.
  final Color color;

  /// The action to perform when the button is pressed or clicked.
  final VoidCallback onPressed;

  /// Returns a copy of this object with the given fields updated.
  CommandButton copyWith({
    Key? key,
    Color? color,
    VoidCallback? onPressed,
  }) {
    return CommandButton(
      key: key ?? this.key,
      color: color ?? this.color,
      onPressed: onPressed ?? this.onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: StreamSvgIcon.lightning(
        color: color,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        height: 24,
        width: 24,
      ),
      splashRadius: 24,
      onPressed: onPressed,
    );
  }
}
