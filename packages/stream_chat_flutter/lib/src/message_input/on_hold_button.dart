import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';

/// {@template commandButton}
/// The button that allows a user to use commands in a chat.
/// {@endtemplate}
class OnHoldButton extends StatelessWidget {
  /// {@macro commandButton}
  const OnHoldButton({
    super.key,
    required this.icon,
    required this.onHold,
  });

  /// Audio Record button
  factory OnHoldButton.audioRecord({
    required Color color,
    required VoidCallback onHold,
  }) {
    return OnHoldButton(
      icon: StreamSvgIcon.microphone(color: color),
      onHold: onHold,
    );
  }

  /// Icon of the button
  final StreamSvgIcon icon;

  /// The action to perform when the button is pressed or clicked.
  final VoidCallback onHold;

  /// Returns a copy of this object with the given fields updated.
  OnHoldButton copyWith({
    Key? key,
    StreamSvgIcon? icon,
    VoidCallback? onHold,
  }) {
    return OnHoldButton(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      onHold: onHold ?? this.onHold,
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
      onPressed: onHold,
    );
  }
}
