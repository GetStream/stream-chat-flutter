import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';

/// {@template onPressButton}
/// The button that allows a user to use commands in a chat. Use the factory
/// constructors of this button to create pre defined buttons.
/// {@endtemplate}
class OnPressButton extends StatelessWidget {
  /// {@macro onPressButton}
  const OnPressButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.padding,
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

  /// Command button
  factory OnPressButton.confirmAudio({
    required VoidCallback onPressed,
  }) {
    return OnPressButton(
      icon: StreamSvgIcon.checkSend(),
      onPressed: onPressed,
    );
  }

  /// Command button
  factory OnPressButton.pauseRecord({
    required VoidCallback onPressed,
  }) {
    return OnPressButton(
      icon: StreamSvgIcon.pause(color: Colors.red),
      onPressed: onPressed,
    );
  }

  /// Command button
  factory OnPressButton.resumeRecord({
    required VoidCallback onPressed,
  }) {
    return OnPressButton(
      icon: StreamSvgIcon.microphone(color: Colors.red),
      onPressed: onPressed,
    );
  }

  /// Command button
  factory OnPressButton.cancelRecord({
    required VoidCallback onPressed,
  }) {
    return OnPressButton(
      icon: StreamSvgIcon.delete(color: Colors.blue),
      onPressed: onPressed,
    );
  }

  /// Icon of the button
  final StreamSvgIcon icon;

  /// The action to perform when the button is pressed or clicked.
  final VoidCallback onPressed;

  ///Docs
  final EdgeInsetsGeometry? padding;

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
      padding: padding ?? EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        height: 24,
        width: 24,
      ),
      splashRadius: 24,
      onPressed: onPressed,
    );
  }
}
