import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';

/// {@template recordButton}
/// Record button that start the recording process. This button doesn't have
/// any logic related to recording, this should be provided in the callbacks.
/// This button allows to set callback to onHold and onPressed.
/// {@endtemplate}
class RecordButton extends StatelessWidget {
  /// {@macro recordButton}
  const RecordButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.onHold,
    this.padding,
  });

  /// Creates the default button to start the recording.
  const RecordButton.startButton({
    Key? key,
    required VoidCallback onHold,
    VoidCallback? onPressed,
  }) : this(
          key: key,
          onHold: onHold,
          icon: const StreamSvgIcon.microphone(size: 20),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
        );

  /// Callback for holding the button.
  final VoidCallback? onHold;

  /// Callback for pressing the button.
  final VoidCallback? onPressed;

  /// Icon of the button.
  final Widget icon;

  /// Padding of button
  final EdgeInsetsGeometry? padding;

  /// Returns a copy of this object with the given fields updated.
  RecordButton copyWith({
    Key? key,
    StreamSvgIcon? icon,
    VoidCallback? onPressed,
    VoidCallback? onHold,
  }) {
    return RecordButton(
      key: key ?? this.key,
      icon: icon ?? this.icon,
      onPressed: onPressed ?? this.onPressed,
      onHold: onHold ?? this.onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onHold?.call();
      },
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8),
        child: IconButton(
          icon: icon,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(
            height: 24,
            width: 24,
          ),
          splashRadius: 24,
          onPressed: () {
            onPressed?.call();
          },
        ),
      ),
    );
  }
}
