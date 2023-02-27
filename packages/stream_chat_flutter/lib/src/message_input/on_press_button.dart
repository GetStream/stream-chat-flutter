import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';

/// {@template commandButton}
/// The button that allows a user to use commands in a chat.
/// {@endtemplate}
class OnPressButton extends StatelessWidget {
  /// {@macro commandButton}
  const OnPressButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  /// Attachment button
  factory OnPressButton.attachment({
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OnPressButton(
      icon: StreamSvgIcon.attach(color: color),
      onPressed: onPressed,
    );
  }

  /// Command button
  factory OnPressButton.command({
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OnPressButton(
      icon: StreamSvgIcon.lightning(color: color),
      onPressed: onPressed,
    );
  }

  /// Audio Record button
  factory OnPressButton.audioRecord({
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OnPressButton(
      icon: StreamSvgIcon.microphone(color: color),
      onPressed: onPressed,
    );
  }

  /// Icon of the button
  final StreamSvgIcon icon;

  /// The action to perform when the button is pressed or clicked.
  final VoidCallback onPressed;

  /// Returns a copy of this object with the given fields updated.
  OnPressButton copyWith({
    Key? key,
    StreamSvgIcon? icon,
    VoidCallback? onPressed,
  }) {
    return OnPressButton(
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
