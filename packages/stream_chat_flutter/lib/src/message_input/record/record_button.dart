import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';

///Docs
class RecordButton extends StatelessWidget {
  ///Docs
  const RecordButton({
    super.key,
    this.onHold,
    this.onPressed,
    required this.icon,
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
    );
  }

  /// Creates the button to resume the recording.
  factory RecordButton.resumeButton({
    required VoidCallback onPressed,
  }) {
    return RecordButton(
      onPressed: onPressed,
      icon: StreamSvgIcon.microphone(
        color: Colors.red,
      ),
    );
  }

  /// Callback for holding the button.
  final VoidCallback? onHold;

  /// Callback for pressing the button.
  final VoidCallback? onPressed;

  /// Icon of the button.
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onHold?.call();
      },
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
    );
  }
}
