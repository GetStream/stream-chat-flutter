import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';

///Docs
class RecordButton extends StatelessWidget {
  ///Docs
  const RecordButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.onHold,
    this.padding,
  });

  /// Creates the button to start the recording.
  factory RecordButton.startButton({
    required VoidCallback onHold,
    VoidCallback? onPressed,
  }) {
    return RecordButton(
      onHold: onHold,
      icon: StreamSvgIcon.microphone(size: 20),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
    );
  }

  /// Callback for holding the button.
  final VoidCallback? onHold;

  /// Callback for pressing the button.
  final VoidCallback? onPressed;

  /// Icon of the button.
  final Widget icon;

  ///Docs
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
