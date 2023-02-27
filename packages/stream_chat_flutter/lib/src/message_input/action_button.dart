import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';

/// {@template commandButton}
/// The button that allows a user to use commands in a chat.
/// {@endtemplate}
class ActionButton extends StatelessWidget {
  /// {@macro commandButton}
  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  /// Attachment button
  factory ActionButton.attachment({
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ActionButton(
      icon: StreamSvgIcon.attach(color: color),
      onPressed: onPressed,
    );
  }

  /// Command button
  factory ActionButton.command({
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ActionButton(
      icon: StreamSvgIcon.lightning(color: color),
      onPressed: onPressed,
    );
  }

  /// Audio Record button
  factory ActionButton.audioRecord({
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ActionButton(
      icon: StreamSvgIcon.microphone(color: color),
      onPressed: onPressed,
    );
  }

  /// Icon of the button
  final StreamSvgIcon icon;

  /// The action to perform when the button is pressed or clicked.
  final VoidCallback onPressed;

  /// Returns a copy of this object with the given fields updated.
  ActionButton copyWith({
    Key? key,
    StreamSvgIcon? icon,
    VoidCallback? onPressed,
  }) {
    return ActionButton(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      onPressed: onPressed ?? this.onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
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
